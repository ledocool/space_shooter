extends Node
class_name Cannon

signal shoot_bullet(bullet_type, shot_modifier)
signal bullets_changed(ammo)
signal weapon_changed(weaponType)

var CannonFiring = false
var CannonLocked = false
var BulletDamageMultiplier: float = 1.0

var CurrentWeapon: String = ""
var RemainningAmmo: int = 0
var MaxAmmo: int = 0
var BulletType = null


func _init():
	set_physics_process(true)


func _physics_process(_delta):
	_tryShoot()
	

func SetWeapon(name: String, data):
	if(data && data is Dictionary && data.enabled == true):
		CurrentWeapon = name
		RemainningAmmo = data.total_ammo
		BulletType = load(data.ammo_type)
		MaxAmmo = data.max_ammo
		($CannonCooldownTimer as Timer).set_wait_time(data.shoot_timeout)
		
		if(data.shoot_cooldown > 0):
			($CannonAfterburnTimer as Timer).set_wait_time(data.shoot_cooldown)
			($CannonAfterburnTimer as Timer).start()
		
		emit_signal("bullets_changed", RemainningAmmo)
		emit_signal("weapon_changed", CurrentWeapon)
		return true
	else:
		print_debug("Could not select weapon of type " + name)
		emit_signal("bullets_changed", RemainningAmmo)
		emit_signal("weapon_changed", CurrentWeapon)
		return false


func UnsetWeapon() -> Dictionary:
	($CannonCooldownTimer as Timer).stop()
	
	var storedData = {}
	storedData.total_ammo = RemainningAmmo
	storedData.shoot_cooldown = ($CannonCooldownTimer as Timer).get_time_left()
	
	_setDefault()	
	return storedData


func CheckShootPossible() -> bool:
	if(($CannonAfterburnTimer as Timer).is_stopped() 
			&& ($CannonCooldownTimer as Timer).is_stopped() 
			&& RemainningAmmo != 0 
			&& BulletType != null):
		if(RemainningAmmo > 0):
			RemainningAmmo -= 1
		($CannonCooldownTimer as Timer).start()
		return true
	return false


func _tryShoot():
	if(!CannonLocked && CannonFiring && CheckShootPossible()):
		_shoot()

func _setDefault():
	CurrentWeapon = ""
	RemainningAmmo = 0
	BulletType = null
	MaxAmmo = 0


func _shoot():
	emit_signal("shoot_bullet", BulletType, BulletDamageMultiplier)
	emit_signal("bullets_changed", RemainningAmmo)
	return true




