class_name StatusWorker

var StatusArray: Array = []
var Target = null

func _init(target: Node2D):
	Target = weakref(target)

func Save():
	return { "statuses": StatusArray }

func Load(data: Dictionary):
	StatusArray = data.statuses

func AddStatus(status):
	StatusArray.append(status)
	
func RemoveStatus(status):
	StatusArray.erase(status)
	
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
