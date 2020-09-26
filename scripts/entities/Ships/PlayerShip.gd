extends Ship
class_name PlayerShip

signal shoot_bullet(bullet_type, direction, location, velocity, damage_multiplier)
signal spawn_item(item)
signal status_added(statusName, statusTimeout)
signal status_removed(statusName)

var InventoryInstance = Inventory.new()
var StatusWrk = StatusWorker.new(self)
var DamageOnBump = false

func _ready():
# warning-ignore:return_value_discarded
	($"Cannon" as Cannon).connect("shoot_bullet", self, "_on_bullet_shot")
# warning-ignore:unsafe_cast
# warning-ignore:return_value_discarded
# warning-ignore:unsafe_cast
	(StatusWrk as StatusWorker).connect("status_added", self, "_on_status_added")
# warning-ignore:return_value_discarded
# warning-ignore:unsafe_cast
	(StatusWrk as StatusWorker).connect("status_removed", self, "_on_status_removed")


func SwitchWeapon(wpnType):
	var currentWeaponBackup = _removeWeapon()
	var success = _selectWeapon(wpnType)
	if(!success):
		_selectWeapon(currentWeaponBackup)


func Load(data: Dictionary):
	InventoryInstance.SetAllWeapons(data.weapons)
	InventoryInstance.SetAllItems(data.items)
	StatusWrk.Load(data.statuses)
	if(data.current_weapon):
		SwitchWeapon(data.current_weapon)
	(self as RigidBody2D).set_sleeping(false)
	return .Load(data)


func Save():
	var data = .Save()
	var cwpn = _removeWeapon()
	data.weapons = InventoryInstance.GetAllWeapons()
	data.items = InventoryInstance.GetAllItems()
	data.current_weapon = cwpn
	data.statuses = StatusWrk.Save()
	_selectWeapon(cwpn)
	return data


func GetInventory() -> Dictionary:
	var currentWpn = _removeWeapon()
	var data = {
		"weapons": InventoryInstance.GetAllWeapons(),
		"items": InventoryInstance.GetAllItems(),
		"current_weapon": currentWpn
	}
	_selectWeapon(currentWpn)
	
	return data


func SetInventory(data: Dictionary):
	InventoryInstance.SetAllWeapons(data.weapons)
	InventoryInstance.SetAllItems(data.items)
	_selectWeapon(data.current_weapon)


func PickUp(item: Pickup, position):
	var switchToWeapon = _removeWeapon()
	var result = PickupHelper.ProcessPickup(item, InventoryInstance, self, StatusWrk, position)
	if(result && switchToWeapon == "" && item.get_type() == 0):
		switchToWeapon = item.get_name()
	if(result == true && item.get_info().has("popup_message")):
# warning-ignore:unsafe_method_access
		$"/root/OverlayLayer".ShowTimedNotificatiopn(item.get_info().popup_message, 1.2)
	SwitchWeapon(switchToWeapon)
	return result


func AddKey(key: KeyCube):
	key.SetTarget(self)
	emit_signal("spawn_item", key)


func Damage(points: int):
	var damaged = .Damage(points)
# warning-ignore:unsafe_property_access
	if(damaged && !$Sounds/Damage/Dmg1.playing):
# warning-ignore:unsafe_method_access
		$Sounds/Damage/Dmg1.play()


func _input(event):
	if event.is_action_pressed("shoot"):
# warning-ignore:unsafe_property_access
		($"Cannon" as Cannon).CannonFiring = true
	elif event.is_action_released("shoot"):
# warning-ignore:unsafe_property_access
		($"Cannon" as Cannon).CannonFiring = false
	
	if event.is_action_pressed("engine_fire"):
		EngineFiring = true
	elif event.is_action_released("engine_fire"):
		EngineFiring = false
		
	if event.is_action_pressed("wpn_1"):
		SwitchWeapon("slug")
	elif event.is_action_pressed("wpn_2"):
		SwitchWeapon("rocketeer")


func _physics_process(delta):
	StatusWrk._physics_process(delta)
	Cursor = get_global_mouse_position()


func _removeWeapon():
	var oldCurrentWeapon = ($"Cannon" as Cannon).CurrentWeapon
	var storedData = InventoryInstance.GetWeapon(oldCurrentWeapon)
	if(storedData && storedData.enabled):
		var weapon = ($"Cannon" as Cannon).UnsetWeapon()
		for key in weapon.keys():
			storedData[key] = weapon[key]
		InventoryInstance.SetWeapon(oldCurrentWeapon, storedData)
	return oldCurrentWeapon


func _selectWeapon(weapon: String):
	var data = InventoryInstance.GetWeapon(weapon)
	if(data != null):
		return ($"Cannon" as Cannon).SetWeapon(weapon, data)
	else:
		return false


func _on_bullet_shot(bullet_type, damage_multiplier):
	emit_signal("shoot_bullet", 
		bullet_type, 
		GetRotation(), 
		($BulletAnchor as Position2D).get_global_position(), 
		GetVelocity(), 
		damage_multiplier)


func _on_PlayerShip_body_entered(body):
	if(DamageOnBump && body.has_method("Damage")):
		body.Damage(9999999999)


func _on_status_added(statusName, duration):
	emit_signal("status_added", statusName, duration)
	
func _on_status_removed(statusName):
	emit_signal("status_removed", statusName)
