class_name StatusWorker

signal status_added(statusName, statusTimeout)
signal status_removed(statusName)

var StatusArray: Array = []
var Target = null

var StatusFileDictionary = {
	"BerserkStatus": "res://scripts/systems/status/Statuses/BerserkStatus.gd",
	"HealingStatus": "res://scripts/systems/status/Statuses/HealingStatus.gd",
	"QuadDamageStatus": "res://scripts/systems/status/Statuses/QuadDamageStatus.gd",
	"SpeedupStatus": "res://scripts/systems/status/Statuses/SpeedupStatus.gd"
}


func _init(target: Node2D):
	Target = weakref(target)


func Save():
	var statusDataArray = []
	
	for status in StatusArray:
		if(status.has_method("Save")):
			statusDataArray.append({
				"type": status.GetType(),
				"data": status.Save()
			})

	return statusDataArray


func Load(data: Array):
	for status in data:
		if(!StatusFileDictionary.has(status.type)):
			print_debug("Unknown player status: " + status.type)
			continue
			
		var statusClass = load(StatusFileDictionary.get(status.type))
		var statusInstance = statusClass.new()
		statusInstance.Load(status.data)
		AddStatus(statusInstance)


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
