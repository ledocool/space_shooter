class_name Inventory

var weapons = {
	"slug": {
		"enabled": false,
		"total_ammo": -1,
		"max_ammo": -1,
		"shoot_timeout": 0.07,
		"shoot_cooldown": 0,
		"ammo_type": "res://scenes/entities/ConcreteEntities/Bullets/Bullet.tscn",
	},
	"rocketeer": {
		"enabled": false,
		"total_ammo": 20,
		"max_ammo": 20,
		"shoot_timeout": 1.2,
		"shoot_cooldown": 0,
		"ammo_type": "res://scenes/entities/ConcreteEntities/Bullets/Rocket.tscn",
	},
#	"railgun": {
#		"enabled": false,
#		"total_ammo": 0,
#		"max_ammo": -1,
#		"magazin_ammo": 0,
#		"shoot_timeout": 300,
#		"ammo_type": "",
#	}
}
	
var	items = {
}

func GetWeapon(wpnType):
	if(weapons.has(wpnType)):
		return weapons[wpnType]
	return null;

func SetWeapon(wpnType, data):
	if(weapons.has(wpnType)):
		weapons[wpnType] = data
		return true
	return false
	
func GetItem(itmType):
	if(items.has(itmType)):
		return items[itmType]
	return null

func SetItem(itmType, data):
	if(items.has(itmType)):
		items[itmType] = data
		return true
	return false

func GetAllWeapons():
	return weapons
	
func SetAllWeapons(wns: Dictionary):
	weapons = wns
	
func GetAllItems():
	return items
	
func SetAllItems(itms: Dictionary):
	items = itms
	
