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
	var storedData = {}
	storedData.total_ammo = RemainningAmmo
	storedData.shoot_cooldown = ($CannonCooldownTimer as Timer).time_left
	($CannonCooldownTimer as Timer).stop()
	
	_setDefault()	
	return storedData


func CheckShootPossible() -> bool:
	if(($CannonCooldownTimer as Timer).is_stopped() \
				&& ($CannonAfterburnTimer as Timer).is_stopped() \
				&& RemainningAmmo != 0 \
				&& BulletType != null):
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
	if BulletType == null:
		return false

	($CannonCooldownTimer as Timer).start()
	if(RemainningAmmo > 0):
		RemainningAmmo -= 1

	var bullet = BulletType.instance()
	bullet._init(BulletDamageMultiplier)

	emit_signal("shoot_bullet", bullet, BulletDamageMultiplier)
	emit_signal("bullets_changed", RemainningAmmo)
	return true




