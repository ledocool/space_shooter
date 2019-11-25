extends RigidBody2D
class_name Ship

signal shoot_bullet(bullet_type, direction, location, velocity)
signal health_changed(newHealth)
signal speed_changed(spd)
signal coordinates_changed(coords)
signal exploded(position, size, rotation)
signal bullets_changed(ammo, maxAmmo)
signal weapon_changed(weaponType)

export var ShipDamageInvulnerability = 3
export var BlinkSpeed = 0.18
var InvulnerabilityCooldown = 0

export var ShipSpeed = 300
export var ShipTopSpeed = 900
export var ShipMaxHealth = 5
export var ShipCurrentHealth = 5
export var VelocityDampThreshold = 180

var Cursor = null
var EngineFiring = false
var EngineFiringLastTime = false
var BlinkCooldown = 0

var CannonFiring = false
var CannonCooldownTimeout = 0.07
var CannonCooldown = 0
var CurrentWeapon: String = ""
var CurrentAmmo: int = 0
var RemainningAmmo: int = 0
var MaxAmmo: int = 0
var BulletType = null

onready var InventoryInstance = Inventory.new()
#onready var StatusInstance = Array()

#func AssumeStatus(status):
#	pass
	
func Pickup(item: Pickup):
	match(item.get_type()):
		0:
			var data = InventoryInstance.GetWeapon(item.get_name())
			if(!data):
				return false
			data.enabled = true
			var result = InventoryInstance.SetWeapon(item.get_name(), data)
			if(result && CurrentWeapon.empty()):
				SwitchWeapon(item.get_name())
			return result
		1:
			pass	
		2:
			pass
			
	print_debug("Item of unknown type: " + item.get_type())
	return false;

func Damage(points: int):
	if(InvulnerabilityCooldown <= 0):
		ShipCurrentHealth = 0 if ShipCurrentHealth < points else ShipCurrentHealth - points
		emit_signal("health_changed", ShipCurrentHealth)
		InvulnerabilityCooldown = ShipDamageInvulnerability

func Destroy():
	_onDestruction()
	self.queue_free()

func GetHealth():
	return ShipCurrentHealth
	
func GetMaxHealth():
	return ShipMaxHealth

func SetMaxHealth(value: int):
	ShipMaxHealth = value

func Heal(points: int):
	ShipCurrentHealth = ShipMaxHealth if ShipCurrentHealth + points > ShipMaxHealth else ShipCurrentHealth + points
	emit_signal("health_changed", ShipCurrentHealth)

func GetCoordinates():
	return position
	
func GetRotation():
	return rotation
	
func GetVelocity(): 
	return linear_velocity

func SwitchWeapon(wpnType):
	if(!CurrentWeapon.empty()):
		_removeWeapon()
	_selectWeapon(wpnType)
	emit_signal("bullets_changed", CurrentAmmo, RemainningAmmo - CurrentAmmo)
	emit_signal("weapon_changed", wpnType)




func _init():
	contact_monitor = true

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
	_reduceCooldowns(delta)
	_tryShoot()
	_applySpeed(newRot, oldRot)
	var spd = linear_velocity.length()
	if(spd < VelocityDampThreshold && EngineFiring == false):
		linear_damp = 5
	else:
		linear_damp = 0
	emit_signal("speed_changed", spd)
	if(spd > 1e-6):
		emit_signal("coordinates_changed", position);
	
func _reduceCooldowns(delta):	
	if(CannonCooldown > 0):
		CannonCooldown -= delta
	if(InvulnerabilityCooldown > 0):
		InvulnerabilityCooldown -= delta
		if(InvulnerabilityCooldown <= 0):
			self.show()
		
func _onDestruction():
	emit_signal("exploded", position, 0.15, rotation)
		
func _tryShoot():
	if(CannonFiring && CannonCooldown <= 0):
		_shoot()
		CannonCooldown = CannonCooldownTimeout
	
func _applySpeed (newRot, oldRot):
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

func _shoot():
	if(BulletType != null):
		emit_signal("shoot_bullet", BulletType, rotation, ($BulletAnchor as Node2D).global_position, linear_velocity)
	
func _removeWeapon():
	var storedData = InventoryInstance.GetWeapon(CurrentWeapon)
	if(storedData):
		storedData.total_ammo = RemainningAmmo
		storedData.magazin_ammo = CurrentAmmo
		InventoryInstance.SetWeapon(CurrentWeapon, storedData)
	else:
		print_debug("Could not remove weapon of type " + CurrentWeapon)
		
	CurrentWeapon = ""	
	CurrentAmmo = 0
	RemainningAmmo = 0
	BulletType = null
	
func _selectWeapon(weapon: String):
	var data = InventoryInstance.GetWeapon(weapon)
	if(data && data.enabled == true):
		CurrentWeapon = weapon
		MaxAmmo = data.max_ammo
		CurrentAmmo = data.magazin_ammo
		RemainningAmmo = data.total_ammo
		BulletType = load(data.ammo_type)
	else:
		print_debug("Could not select weapon of type " + weapon)