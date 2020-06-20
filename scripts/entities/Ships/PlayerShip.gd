extends Ship
class_name PlayerShip

signal shoot_bullet(bullet_type, direction, location, velocity, damage_multiplier)

var InventoryInstance = Inventory.new()
var StatusWrk = StatusWorker.new(self)
onready var CannonInstance = $Cannon
var DamageOnBump = false

func _ready():
	CannonInstance.connect("shoot_bullet", self, "_on_bullet_shot")

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


func _on_bullet_shot(bullet_type, damage_multiplier):
	emit_signal("shoot_bullet", 
		bullet_type, GetRotation(), 
		($BulletAnchor as Position2D).get_global_position(), 
		GetVelocity(), damage_multiplier)


func _on_PlayerShip_body_entered(body):
	if(DamageOnBump && body.has_method("Damage")):
		body.Damage(9999999999)
