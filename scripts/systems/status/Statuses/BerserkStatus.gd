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
	OldDamageMultiplier = target.ReceivedDamageMultiplier
	target.ReceivedDamageMultiplier = ModifiedDamageMultiplier
	target.CannonInstance.CannonLocked = true
	target.DamageOnBump = true


func _onStatusExit(target: PlayerShip):
	target.ReceivedDamageMultiplier = OldDamageMultiplier
	target.DamageOnBump = false
	target.CannonInstance.CannonLocked = false
	
	
func CanApply(target: PlayerShip) -> bool:
	return target.StatusWrk.HasStatus(typeof(self)) == false
