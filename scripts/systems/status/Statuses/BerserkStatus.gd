extends Status
class_name BerserkStatus

var ModifiedDamageMultiplier:float = 0
var OldDamageMultiplier: float = 0

var StatusTimeout: float = 30

func IsStatusDead():
	return StatusTimeout <= 0


func GetStatusTimeout() -> float:
	return StatusTimeout


func Process(delta: float, _target: Ship):
	StatusTimeout -= delta


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
	

func Save():
	return {
		"timeout": StatusTimeout
	}


func Load(data: Dictionary):
	StatusTimeout = data.timeout
