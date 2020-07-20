extends Status
class_name BerserkStatus

var ModifiedDamageMultiplier:float = 0
var OldDamageMultiplier: float = 0

var statusTimeout = 300

func IsStatusDead():
	return statusTimeout <= 0


func Process(delta: float, _target: Ship):
	statusTimeout -= delta


func _onStatusEnter(target: PlayerShip):
	var cannon = target.get_node("Cannon") as Cannon
	if(cannon == null):
		return
	OldDamageMultiplier = target.ReceivedDamageMultiplier
	target.ReceivedDamageMultiplier = ModifiedDamageMultiplier
	cannon.CannonLocked = true
	target.DamageOnBump = true


func _onStatusExit(target: PlayerShip):
	var cannon = target.get_node("Cannon") as Cannon
	if(cannon == null):
		return
	target.ReceivedDamageMultiplier = OldDamageMultiplier
	target.DamageOnBump = false
	cannon.CannonLocked = false
	
	
func CanApply(target: PlayerShip) -> bool:
	return target.StatusWrk.HasStatus(GetType()) == false


func GetType() -> String:
	return "BerserkStatus"
