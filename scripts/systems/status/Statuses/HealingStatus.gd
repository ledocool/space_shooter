extends Status
class_name HealingStatus

var Dead = false
var HealAmount = 10


func IsStatusDead():
	return Dead


func GetStatusTimeout() -> float:
	return 0.0


func Process(_delta, target):
	if(target.has_method("Heal")):
		target.Heal(HealAmount)
	Dead = true


func CanApply(target: PlayerShip) -> bool:
	return target.ShipCurrentHealth < target.ShipMaxHealth


func GetType() -> String:
	return "HealingStatus"


func Save():
	return {
		"dead" : Dead
	}


func Load(data: Dictionary):
	Dead = data.dead
