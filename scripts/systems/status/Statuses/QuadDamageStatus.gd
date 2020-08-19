extends Status
class_name QuadDamageStatus

var ModifiedDmgMultiplier:float = 4
var OldDmgMultiplier: float = 0

var StatusTimeout = 40

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
	OldDmgMultiplier = cannon.BulletDamageMultiplier
	cannon.BulletDamageMultiplier = ModifiedDmgMultiplier


func _onStatusExit(target: PlayerShip):
	var cannon = target.get_node("Cannon") as Cannon
	if(cannon == null):
		return
	cannon.BulletDamageMultiplier = OldDmgMultiplier
	
func CanApply(target: PlayerShip) -> bool:
# warning-ignore:unsafe_property_access
	return target.StatusWrk.HasStatus(GetType()) == false


func GetType() -> String:
	return "QuadDamageStatus"


func Save():
	return {
		"timeout": StatusTimeout
	}


func Load(data: Dictionary):
	StatusTimeout = data.timeout
