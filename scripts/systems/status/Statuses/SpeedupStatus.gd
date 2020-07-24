extends Status
class_name SpeedupStatus

var ModifiedSpeedMultiplier:float = 2
var OldSpeedMultiplier: float = 0

var statusTimeout = 60

func IsStatusDead():
	return statusTimeout <= 0


func GetStatusTimeout() -> float:
	return statusTimeout


func Process(delta: float, _target: Ship):
	statusTimeout -= delta


func _onStatusEnter(target: Ship):
	OldSpeedMultiplier = target.SpeedMultiplier
	target.SpeedMultiplier = ModifiedSpeedMultiplier


func _onStatusExit(target: Ship):
	target.SpeedMultiplier = OldSpeedMultiplier


func CanApply(target: PlayerShip) -> bool:
	return target.StatusWrk.HasStatus(GetType()) == false


func GetType() -> String:
	return "SpeedupStatus"
