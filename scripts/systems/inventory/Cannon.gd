extends Node
class_name Cannon

onready var cannonCooldownTimer: Timer = $CannonCooldownTimer
onready var cannonAfterburnTimer: Timer = $CannonAfterburnTimer

#"slug": {
#		"enabled": false,
#		"total_ammo": -1,
#		"max_ammo": -1,
#		"shoot_timeout": 0.3,
#		"shoot_cooldown": 0,
#		"ammo_type": "res://scenes/entities/ConcreteEntities/Bullets/Bullet.tscn",
#	},

var CurrentWeapon: String = ""
var RemainningAmmo: int = 0
var MaxAmmo: int = 0
var BulletType = null

func _init():
	set_physics_process(true)

func SetWeapon(name: String, data):
	if(data && data is Dictionary && data.enabled == true):
		CurrentWeapon = name
		RemainningAmmo = data.total_ammo
		BulletType = load(data.ammo_type)
		MaxAmmo = data.max_ammo
		cannonCooldownTimer.set_wait_time(data.shoot_timeout)
		
		if(data.shoot_cooldown > 0):
			cannonAfterburnTimer.set_wait_time(data.shoot_cooldown)
			cannonAfterburnTimer.start()
			
		return true
	else:
		print_debug("Could not select weapon of type " + name)
		return false


func UnsetWeapon() -> Dictionary:
	cannonCooldownTimer.stop()
	
	var storedData = {}
	storedData.total_ammo = RemainningAmmo
	storedData.shoot_cooldown = cannonCooldownTimer.get_time_left()
	
	_setDefault()
	
	return storedData


func TryShoot() -> bool:
	if(cannonAfterburnTimer.is_stopped() && cannonCooldownTimer.is_stopped() && RemainningAmmo != 0 && BulletType != null):
		if(RemainningAmmo > 0):
			RemainningAmmo -= 1
		cannonCooldownTimer.start()
		return true
	return false


func _setDefault():
	CurrentWeapon = ""
	RemainningAmmo = 0
	BulletType = null
	MaxAmmo = 0
