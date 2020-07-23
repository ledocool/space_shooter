extends Status
class_name BerserkStatus

var ModifiedDamageMultiplier:float = 0
var OldDamageMultiplier: float = 0

var statusTimeout = 30

func IsStatusDead():
	return statusTimeout <= 0


func GetStatusTimeout() -> float:
	return statusTimeout


func Process(delta: float, _target: Ship):
	statusTimeout -= delta


func _onStatusEnter(target: PlayerShip):
	var cannon = target.get_node("Cannon") as Cannon
	if(cannon == null):
		return
	OldDamageMultiplier = target.ReceivedDamageMultiplier
	target.ReceivedDamageMultiplier = ModifiedDamageMultiplier
	cannon.CannonLocked = true
# warning-ignore:unsafe_property_access
	target.DamageOnBump = true


func _onStatusExit(target: PlayerShip):
	var cannon = target.get_node("Cannon") as Cannon
	if(cannon == null):
		return
	target.ReceivedDamageMultiplier = OldDamageMultiplier
# warning-ignore:unsafe_property_access
	target.DamageOnBump = false
	cannon.CannonLocked = false
	
	
func CanApply(target: PlayerShip) -> bool:
# warning-ignore:unsafe_property_access
	return target.StatusWrk.HasStatus(GetType()) == false


func GetType() -> String:
	return "BerserkStatus"
