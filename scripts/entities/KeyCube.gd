extends KinematicBody2D
class_name KeyCube

signal exploded(position, size, rotation)

var LoadTargetPath = null
var Target: WeakRef
var TargetPosition = Vector2()
export var Speed: float = 920
export var CalmDistance: float = 100
export var AgitatedDistance: float = 500
export var RotateRadius: float = 350
var RotateAngle: float = 0

func Save() -> Dictionary:
	var tg = Target.get_ref()
	var tgPath = null
	if(tg):
		tgPath = get_path_to(tg)

	return {
		"target": tgPath,
		"position": position
	}
	
func Load(data: Dictionary):
	position = LoadHelper.StringToVector2(data.position)
	LoadTargetPath = data.target

func Destroy():
	_onDestruction()
	self.queue_free()


func SetTarget(target):
	Target = weakref(target)


func SpawnAt(Position: Vector2):
	self.position = Position


func _ready():
	if(LoadTargetPath != null):
		var ref = get_node_or_null(LoadTargetPath)
		Target = weakref(ref)
	
	_on_UpdateCoordinatesTimer_timeout()
	var level = $"/root/Level"
	if(level != null):
		connect("exploded", level, "_on_Something_explode")


func _physics_process(delta):
	RotateAngle += delta + PI/136
	
	var fromTo = TargetPosition - self.position
	var currentSpeed = Speed * (fromTo.length() - CalmDistance) / (AgitatedDistance - CalmDistance)
	if(currentSpeed > Speed):
		currentSpeed = Speed
	if(currentSpeed < 0):
		currentSpeed = 0
	
	var moveVector = fromTo.normalized() * currentSpeed
	
# warning-ignore:return_value_discarded
	move_and_slide(moveVector)


func _on_UpdateCoordinatesTimer_timeout():
	var tg = Target.get_ref()
	if (!tg):
		return
	
# warning-ignore:unused_variable
	var targetRadius = Vector2(RotateRadius, 0).rotated(RotateAngle)
	TargetPosition = tg.GetCoordinates()# + targetRadius


func _onDestruction():
	emit_signal("exploded", position, Vector2(0.1, 0.1), rotation)
