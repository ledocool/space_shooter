extends Status
class_name HealingStatus

var dead = false
var healAmount = 10


func IsStatusDead():
	return dead


func Process(_delta, target):
	if(target.has_method("Heal")):
		target.Heal(healAmount)
	dead = true

func CanApply(target: PlayerShip) -> bool:
	return target.GetHealth() < target.GetMaxHealth()
