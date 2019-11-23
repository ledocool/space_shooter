extends RigidBody2D
class_name Ship

signal shoot_bullet(bullet_type, direction, location, velocity)
signal health_changed(newHealth)
signal speed_changed(spd)
signal coordinates_changed(coords)
signal exploded(position, size, rotation)
#signal bullets_changed(ammo, maxAmmo)
#signal weapon_changed(weaponType)

export var ShipDamageInvulnerability = 3
export var BlinkSpeed = 0.18
export var ShipSpeed = 300
export var ShipTopSpeed = 900
export var ShipMaxHealth = 5
export var ShipCurrentHealth = 5
export var VelocityDampThreshold = 180

var InvulnerabilityCooldown = 0
var Cursor = null
var EngineFiring = false
var EngineFiringLastTime = false
var CannonFiring = false
var CannonCooldownTimeout = 0.07
var CannonCooldown = 0
var BlinkCooldown = 0

func _ready():
	pass

func Shoot():
	emit_signal("shoot_bullet", null, rotation, ($BulletAnchor as Node2D).global_position, linear_velocity)

func Damage(points: int):
	if(InvulnerabilityCooldown <= 0):
		ShipCurrentHealth = 0 if ShipCurrentHealth < points else ShipCurrentHealth - points
		emit_signal("health_changed", ShipCurrentHealth)
		InvulnerabilityCooldown = ShipDamageInvulnerability

func Destroy():
	_onDestruction()
	self.queue_free()

func _onDestruction():
	emit_signal("exploded", position, 0.15, rotation)

func GetHealth():
	return ShipCurrentHealth
	
func GetMaxHealth():
	return ShipMaxHealth

func SetMaxHealth(value: int):
	ShipMaxHealth = value

func Heal(points: int):
	ShipCurrentHealth = ShipMaxHealth if ShipCurrentHealth + points > ShipMaxHealth else ShipCurrentHealth + points
	emit_signal("health_changed", ShipCurrentHealth)

func _init():
	contact_monitor = true

func ReduceCooldowns(delta):	
	if(CannonCooldown > 0):
		CannonCooldown -= delta
	if(InvulnerabilityCooldown > 0):
		InvulnerabilityCooldown -= delta
		if(InvulnerabilityCooldown <= 0):
			self.show()

func _process(delta):
	if(BlinkCooldown > 0):
		BlinkCooldown -= delta
	if(InvulnerabilityCooldown > 0 && BlinkCooldown <= 0):
		if(self.visible):
			self.hide()
		else:
			self.show() #= !self.visible
		BlinkCooldown = BlinkSpeed

func _physics_process(delta):
	if (ShipCurrentHealth <= 0):
		self.Destroy()
		return 0
	
	var oldRot = rotation
	if(Cursor != null) :
#		if Cursor is Vector2:
		look_at(Cursor)
#		else:
#			rotation = Cursor
	var newRot = rotation
	ReduceCooldowns(delta)
	TryShoot()
	ApplySpeed(newRot, oldRot)
	var spd = linear_velocity.length()
	if(spd < VelocityDampThreshold && EngineFiring == false):
		linear_damp = 5
	else:
		linear_damp = 0
	emit_signal("speed_changed", spd)
	if(spd > 1e-6):
		emit_signal("coordinates_changed", position);
	
		
func TryShoot():
	if(CannonFiring && CannonCooldown <= 0):
		Shoot()
		CannonCooldown = CannonCooldownTimeout
	
func ApplySpeed (newRot, oldRot):
	var somethingChanged = false
	var force = Vector2(0, 0)
	
	if(EngineFiring && newRot != oldRot):
		force = Vector2(1, 0) * ShipSpeed
		force = force.rotated(rotation)
		somethingChanged = true
	
	if(EngineFiringLastTime != EngineFiring):
		somethingChanged = true
	
	if(somethingChanged):
		EngineFiringLastTime = EngineFiring
		($EngineParticles as Particles2D).emitting = EngineFiring
		applied_force = force
		if(linear_velocity.length_squared() > ShipTopSpeed * ShipTopSpeed):
			set_linear_velocity(get_linear_velocity().clamped(ShipTopSpeed))
	
	
func GetCoordinates():
	return position
	
func GetRotation():
	return rotation
	
func GetVelocity(): 
	return linear_velocity
