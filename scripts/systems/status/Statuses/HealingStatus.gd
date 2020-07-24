extends Status
class_name HealingStatus

var dead = false
var healAmount = 10


func IsStatusDead():
	return dead


func GetStatusTimeout() -> float:
	return 0.0


func Process(_delta, target):
	if(target.has_method("Heal")):
		target.Heal(healAmount)
	dead = true


func CanApply(target: PlayerShip) -> bool:
	return target.ShipCurrentHealth < target.ShipMaxHealth


func GetType() -> String:
	return "HealingStatus"
