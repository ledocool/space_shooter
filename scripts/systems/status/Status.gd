class_name Status


func IsStatusDead():
	return true


func Process(_delta, _target):
	pass


func _onStatusEnter(_target):
	pass


func _onStatusExit(_target):
	pass


func CanApply(_target) -> bool:
	return false


func GetType() -> String:
	return "Status"


func GetStatusTimeout() -> float:
	return 0.0


func Save():
	pass


func Load(_data: Dictionary):
	pass
