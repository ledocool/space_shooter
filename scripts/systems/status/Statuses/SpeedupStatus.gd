extends Status
class_name SpeedupStatus

var ModifiedSpeedMultiplier:float = 2
var OldSpeedMultiplier: float = 0

var StatusTimeout = 60

func IsStatusDead():
	return StatusTimeout <= 0


func GetStatusTimeout() -> float:
	return StatusTimeout


func Process(delta: float, _target: Ship):
	StatusTimeout -= delta


func _onStatusEnter(target: Ship):
	OldSpeedMultiplier = target.SpeedMultiplier
	target.SpeedMultiplier = ModifiedSpeedMultiplier


func _onStatusExit(target: Ship):
	target.SpeedMultiplier = OldSpeedMultiplier


func CanApply(target: PlayerShip) -> bool:
	return target.StatusWrk.HasStatus(GetType()) == false


func GetType() -> String:
	return "SpeedupStatus"


func Save():
	return {
		"timeout": StatusTimeout
	}


func Load(data: Dictionary):
	StatusTimeout = data.timeout
