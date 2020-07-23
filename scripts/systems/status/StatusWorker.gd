class_name StatusWorker

signal status_added(statusName, statusTimeout)
signal status_removed(statusName)

var StatusArray: Array = []
var Target = null

func _init(target: Node2D):
	Target = weakref(target)


func Save():
	return { "statuses": StatusArray }


func Load(data: Dictionary):
	StatusArray = data.statuses


func AddStatus(status):
	var target = Target.get_ref()
	if(target == null):
		return
	
	status._onStatusEnter(target)
	StatusArray.append(status)
	emit_signal("status_added", status.GetType(), status.GetStatusTimeout())
	
	
func RemoveStatus(status):
	var target = Target.get_ref()
	if(target == null):
		return
	
	status._onStatusExit(target)
	StatusArray.erase(status)
	emit_signal("status_removed", status.GetType())


func HasStatus(statusType):
	for status in StatusArray:
		if status.GetType() == statusType:
			return true
	return false


func _physics_process(delta):
	if(StatusArray.empty()):
		return
	
	var target = Target.get_ref()
	if(target == null):
		return
	
	for status in StatusArray:
		status.Process(delta, target)
		if (status.IsStatusDead()):
			RemoveStatus(status)
