extends Status
class_name InvincibilityStatus

var ModifiedDamageMultiplier:float = 0
var OldDamageMultiplier: float = 0

var statusTimeout = 300

func IsStatusDead():
	return statusTimeout > 0


func Process(delta: float, _target: Ship):
	statusTimeout -= delta


func _onStatusEnter(target: Ship):
	OldDamageMultiplier = target.ReceivedDamageMultiplier
	target.ReceivedDamageMultiplier = ModifiedDamageMultiplier


func _onStatusExit(target: Ship):
	target.ReceivedDamageMultiplier = OldDamageMultiplier
