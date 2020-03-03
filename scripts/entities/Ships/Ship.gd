extends RigidBody2D
class_name Ship

signal shoot_bullet(bullet_type, direction, location, velocity)
signal health_changed(oldHealth, newHealth)
signal speed_changed(spd)
signal coordinates_changed(coords)
signal exploded(position, size, rotation)
signal bullets_changed(ammo)
signal weapon_changed(weaponType)

export var ShipSpeed = 300
export var ShipTopSpeed = 900
export var ShipMaxHealth = 5
export var ShipCurrentHealth = 5
export var VelocityDampThreshold = 180
export var ShipRippleScale = 3

var Cursor = null
var EngineFiring = false
var EngineFiringLastTime = false

var CannonFiring = false
var CannonLockedAfterburn = false

var CurrentWeapon: String = ""
var RemainningAmmo: int = 0
var BulletType = null
var OldSpeed = 0

var InventoryInstance = Inventory.new()

onready var Statuses = Array()

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
			var statusName = StatusMap.getStatusPath(item.get_name())
			if (!statusName.empty()):
				var status = load(statusName)
				Statuses.append(status.new(self))
				return true
			return false
		2:
			pass
			
	print_debug("Item of unknown type: " + String(item.get_type()))
	return false;


func Damage(points: int):
	var cooldown = ($Timers/InvulnerabilityTimer as Timer)
	var blink = ($Timers/BlinkTimer as Timer)
	if(cooldown.is_stopped()):
		cooldown.start()
		blink.start()
		var oldShipHealth = ShipCurrentHealth
		ShipCurrentHealth = 0 if ShipCurrentHealth < points else ShipCurrentHealth - points
		emit_signal("health_changed", oldShipHealth, ShipCurrentHealth)


func Save():
	var cwpn = CurrentWeapon
	_removeWeapon()
	return {
		"position": position,
		"velocity": linear_velocity,
		"rotation": rotation,
		"current_weapon": cwpn,
		"weapons": InventoryInstance.GetAllWeapons(),
		"items": InventoryInstance.GetAllItems()
	}


func Load(data: Dictionary):
	InventoryInstance.SetAllWeapons(data.weapons)
	InventoryInstance.SetAllItems(data.items)
	SwitchWeapon(data.current_weapon)
	var pos = data.position.trim_prefix('(').trim_suffix(')').split(',')
	position = Vector2(pos[0], pos[1])
	var vel = data.velocity.trim_prefix('(').trim_suffix(')').split(',')
	linear_velocity = Vector2(vel[0], vel[1])
	rotation = data.rotation


func Destroy():
	_onDestruction()
	self.queue_free()


func GetHealth():
	return ShipCurrentHealth


func GetMaxHealth():
	return ShipMaxHealth


func GetMaxSpeed():
	return ShipTopSpeed


func SetMaxHealth(value: int):
	ShipMaxHealth = value


func Heal(points: int):
	var shipOldHealth = ShipCurrentHealth
	ShipCurrentHealth = ShipMaxHealth if ShipCurrentHealth + points > ShipMaxHealth else ShipCurrentHealth + points
	emit_signal("health_changed", shipOldHealth,  ShipCurrentHealth)


func GetCoordinates():
	return position


func GetRotation():
	return rotation


func GetVelocity(): 
	return linear_velocity


func SwitchWeapon(wpnType):
	var currentWeaponBackup = CurrentWeapon
	if(!CurrentWeapon.empty()):
		_removeWeapon()
	if(_selectWeapon(wpnType)):
		emit_signal("bullets_changed", RemainningAmmo)
		emit_signal("weapon_changed", wpnType)
	else:
		_selectWeapon(currentWeaponBackup)


func _physics_process(delta):
	for status in Statuses:
		status._physics_process(delta)
		if (status.IsStatusDead()):
			Statuses.erase(status)
	
	if (ShipCurrentHealth <= 0):
		self.Destroy()
		return 0
	
	var oldRot = rotation
	if(Cursor != null) :
		look_at(Cursor)
		
	var newRot = rotation
	_tryShoot()
	_applySpeed(newRot, oldRot)
	var spd = linear_velocity.length()
	if(spd < VelocityDampThreshold && EngineFiring == false):
		linear_damp = 5
	else:
		linear_damp = 0
	
	if(spd != OldSpeed):
		OldSpeed = spd
		($Turbulence/Area2D as Area2D).gravity = -ShipRippleScale * spd
		emit_signal("speed_changed", spd)
	if(spd > 1e-6):
		emit_signal("coordinates_changed", position);


func _onDestruction():
	emit_signal("exploded", position, 0.15, rotation)


func _tryShoot():
	var cannonCooldown = $Timers/CannonCooldownTimer as Timer
	if(CannonFiring 
		&& !CannonLockedAfterburn 
		&& cannonCooldown.is_stopped() 
		&& RemainningAmmo != 0):
		if _shoot():
			if(RemainningAmmo > 0):
				RemainningAmmo -= 1
			emit_signal("bullets_changed", RemainningAmmo)
			cannonCooldown.start()


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
		return true
	return false
	
	
func _removeWeapon():
	var storedData = InventoryInstance.GetWeapon(CurrentWeapon)
	if(storedData):
		var cannonCooldown = $Timers/CannonCooldownTimer as Timer
		storedData.total_ammo = RemainningAmmo
		storedData.shoot_cooldown = cannonCooldown.get_time_left()
		cannonCooldown.stop()
		InventoryInstance.SetWeapon(CurrentWeapon, storedData)
	else:
		print_debug("Could not remove weapon of type " + CurrentWeapon)
		
	CurrentWeapon = ""	
	RemainningAmmo = 0
	BulletType = null
	
	
func _selectWeapon(weapon: String):
	var data = InventoryInstance.GetWeapon(weapon)
	if(data && data.enabled == true):
		var cannonCooldown = $Timers/CannonCooldownTimer as Timer
		var cannonAfterburn = $Timers/CannonAfterBurnTimer as Timer
		CurrentWeapon = weapon
		RemainningAmmo = data.total_ammo
		BulletType = load(data.ammo_type)
		cannonCooldown.set_wait_time(data.shoot_timeout)
		if(data.shoot_cooldown > 0):
			CannonLockedAfterburn = true
			cannonAfterburn.set_wait_time(data.shoot_cooldown)
			cannonAfterburn.start()
		return true
	else:
		print_debug("Could not select weapon of type " + weapon)
		return false

func _on_BlinkTimer_timeout():
	if(self.visible):
		self.hide()
	else:
		self.show()


func _on_InvulnerabilityTimer_timeout():
	var blink = $Timers/BlinkTimer as Timer
	blink.stop()
	self.show()


func _on_CannonAfterBurnTimer_timeout():
	CannonLockedAfterburn = false
