extends Status
class_name ShootInabilityStatus

var statusTimeout = 300

func IsStatusDead():
	statusTimeout > 0


func Process(delta: float, _target: PlayerShip):
	statusTimeout -= delta


func _onStatusEnter(target: PlayerShip):
	target.CannonInstance.CannonLocked = true


func _onStatusExit(target: PlayerShip):
	target.CannonInstance.CannonLocked = true
