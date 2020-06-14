extends Ship
class_name PlayerShip

signal shoot_bullet(bullet_type, direction, location, velocity)

var InventoryInstance = Inventory.new()
var StatusWrk = StatusWorker.new(self)
onready var CannonInstance = $Cannon


func _ready():
	var succ = CannonInstance.connect("shoot_bullet", self, "_on_bullet_shot")

func SwitchWeapon(wpnType):
	var currentWeaponBackup = _removeWeapon()
	var success = _selectWeapon(wpnType)
	if(!success):
		_selectWeapon(currentWeaponBackup)


func Load(data: Dictionary):
	InventoryInstance.SetAllWeapons(data.weapons)
	InventoryInstance.SetAllItems(data.items)
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
	_selectWeapon(cwpn)
	return data


func GetInventory():
	return {
		"weapons": InventoryInstance.GetAllWeapons(),
		"items": InventoryInstance.GetAllItems()
	}


func SetInventory(data: Dictionary):
	InventoryInstance.SetAllWeapons(data.weapons)
	InventoryInstance.SetAllItems(data.items)


func PickUp(item: Pickup):
	var switchToWeapon = _removeWeapon()
	var result = PickupHelper.ProcessPickup(item, InventoryInstance, self, StatusWrk)
	if(result && switchToWeapon == "" && item.get_type() == 0):
		switchToWeapon = item.get_name()
	SwitchWeapon(switchToWeapon)
	return result


func _input(event):
	if event.is_action_pressed("shoot"):
		CannonInstance.CannonFiring = true
	elif event.is_action_released("shoot"):
		CannonInstance.CannonFiring = false
	
	if event.is_action_pressed("engine_fire"):
		self.EngineFiring = true
	elif event.is_action_released("engine_fire"):
		self.EngineFiring = false
		
	if event.is_action_pressed("wpn_1"):
		SwitchWeapon("slug")
	elif event.is_action_pressed("wpn_2"):
		SwitchWeapon("rocketeer")


func _physics_process(delta):
	#CannonInstance._physics_process(delta)
	StatusWrk._physics_process(delta)
	self.Cursor = get_global_mouse_position()


func _removeWeapon():
	var oldCurrentWeapon = CannonInstance.CurrentWeapon
	var storedData = InventoryInstance.GetWeapon(oldCurrentWeapon)
	if(storedData && storedData.enabled):
		var weapon = CannonInstance.UnsetWeapon()
		for key in weapon.keys():
			storedData[key] = weapon[key]
		InventoryInstance.SetWeapon(oldCurrentWeapon, storedData)
	return oldCurrentWeapon


func _selectWeapon(weapon: String):
	var data = InventoryInstance.GetWeapon(weapon)
	if(data != null):
		return CannonInstance.SetWeapon(weapon, data)
	else:
		return false


func _on_bullet_shot(bullet_type):
	emit_signal("shoot_bullet", bullet_type, GetRotation(), $BulletAnchor.get_global_position(), GetVelocity())
