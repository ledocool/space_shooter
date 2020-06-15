extends Status
class_name SpeedupStatus

var ModifiedSpeedMultiplier:float = 2
var OldSpeedMultiplier: float = 0

var statusTimeout = 300

func IsStatusDead():
	statusTimeout > 0


func Process(delta: float, _target: Ship):
	statusTimeout -= delta


func _onStatusEnter(target: Ship):
	OldSpeedMultiplier = target.SpeedMultiplier
	target.SpeedMultiplier = ModifiedSpeedMultiplier


func _onStatusExit(target: Ship):
	target.SpeedMultiplier = OldSpeedMultiplier
