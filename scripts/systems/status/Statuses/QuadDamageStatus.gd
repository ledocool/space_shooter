extends Status
class_name QuadDamageStatus

var ModifiedDmgMultiplier:float = 4
var OldDmgMultiplier: float = 0

var statusTimeout = 40

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
	OldDmgMultiplier = cannon.BulletDamageMultiplier
	cannon.BulletDamageMultiplier = ModifiedDmgMultiplier


func _onStatusExit(target: PlayerShip):
	var cannon = target.get_node("Cannon") as Cannon
	if(cannon == null):
		return
	cannon.BulletDamageMultiplier = OldDmgMultiplier
	
func CanApply(target: PlayerShip) -> bool:
	return target.StatusWrk.HasStatus(GetType()) == false


func GetType() -> String:
	return "QuadDamageStatus"
