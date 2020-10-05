extends KinematicBody2D
class_name KeyCube

var Target: WeakRef
var TargetPosition = Vector2()
export var Speed: float = 920
export var CalmDistance: float = 100
export var AgitatedDistance: float = 500
export var RotateRadius: float = 350
var RotateAngle: float = 0

func Destroy():
	_onDestruction()
	self.queue_free()


func SetTarget(target):
	Target = weakref(target)


func SpawnAt(Position: Vector2):
	self.position = Position


func _ready():
	_on_UpdateCoordinatesTimer_timeout()


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
	pass
