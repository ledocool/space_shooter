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
var CannonFiring = false

var EngineFiringLastTime = false

var OldSpeed = 0
var OldForce = Vector2(0,0)

var InventoryInstance = Inventory.new()
var StatusWrk = StatusWorker.new(self)
onready var CannonInstance = $Cannon


func PickUp(item: Pickup):
	var switchToWeapon = CannonInstance.CurrentWeapon
	_removeWeapon()
	var result = PickupHelper.ProcessPickup(item, InventoryInstance, self, StatusWrk)
	if(result && switchToWeapon == "" && item.get_type() == 0):
		switchToWeapon = item.get_name()
	SwitchWeapon(switchToWeapon)
	return result


func Damage(points: int):
	var cooldown = ($Timers/InvulnerabilityTimer as Timer)
	var blink = ($Timers/BlinkTimer as Timer)
	if(cooldown.is_stopped()):
		cooldown.start()
		blink.start()
		var oldShipHealth = ShipCurrentHealth
		ShipCurrentHealth = 0 if ShipCurrentHealth < points else ShipCurrentHealth - points
		emit_signal("health_changed", oldShipHealth, ShipCurrentHealth)
	return true


func GetInventory():
	return {
		"weapons": InventoryInstance.GetAllWeapons(),
		"items": InventoryInstance.GetAllItems()
	}


func SetInventory(data: Dictionary):
	InventoryInstance.SetAllWeapons(data.weapons)
	InventoryInstance.SetAllItems(data.items)


func Save():
	var cwpn = _removeWeapon()
	var data = {
		"position": position,
		"velocity": linear_velocity,
		"rotation": rotation,
		"current_weapon": cwpn,
		"weapons": InventoryInstance.GetAllWeapons(),
		"items": InventoryInstance.GetAllItems()
	}
	_selectWeapon(cwpn)
	return data


func Load(data: Dictionary):
	InventoryInstance.SetAllWeapons(data.weapons)
	InventoryInstance.SetAllItems(data.items)
	if(data.current_weapon):
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
	var currentWeaponBackup = _removeWeapon()
	if(_selectWeapon(wpnType)):
		emit_signal("bullets_changed", CannonInstance.RemainningAmmo)
		emit_signal("weapon_changed", wpnType)
	else:
		_selectWeapon(currentWeaponBackup)


func _integrate_forces(state):
	var oldRot = rotation
	if(Cursor != null):
		look_at(Cursor)
	var newRot = rotation
	_applySpeed(state, newRot, oldRot)


func _physics_process(delta):
	StatusWrk._physics_process(delta)
	
	if (ShipCurrentHealth <= 0):
		self.Destroy()
		return 0
	
	_tryShoot()
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
	emit_signal("exploded", position, 0.15, 0)


func _tryShoot():
	if(CannonFiring && CannonInstance.TryShoot()):
		_shoot()


func _applySpeed (state, newRot, oldRot):
	var force = Vector2(ShipSpeed, 0).rotated(newRot)
	
	if(newRot != oldRot || EngineFiringLastTime != EngineFiring):
		state.add_central_force(-OldForce)
		($EngineParticles as Particles2D).emitting = EngineFiring
		if(EngineFiring):
			state.add_central_force(force)
			OldForce = force
			if(state.linear_velocity.length_squared() > ShipTopSpeed * ShipTopSpeed):
				state.set_linear_velocity(state.get_linear_velocity().clamped(ShipTopSpeed))
		else:
			OldForce = Vector2(0,0)
			
		EngineFiringLastTime = EngineFiring


func _shoot():
	emit_signal("shoot_bullet", CannonInstance.BulletType, rotation, ($BulletAnchor as Node2D).global_position, linear_velocity)
	emit_signal("bullets_changed", CannonInstance.RemainningAmmo)
	return true


func _removeWeapon():
	var storedData = InventoryInstance.GetWeapon(CannonInstance.CurrentWeapon)
	if(storedData):
		var weapon = CannonInstance.UnsetWeapon()
		for key in weapon.keys():
			storedData[key] = weapon[key]
		InventoryInstance.SetWeapon(CannonInstance.CurrentWeapon, storedData)
	return CannonInstance.CurrentWeapon
		


func _selectWeapon(weapon: String):
	var data = InventoryInstance.GetWeapon(weapon)
	if(data != null):
		return CannonInstance.SetWeapon(weapon, data)
	else:
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
