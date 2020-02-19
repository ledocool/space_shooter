tool
extends Node2D
class_name BeamDoor

export (bool) var enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	($Emitter as Node2D).scale = Vector2(1/scale.x, 1/scale.y)
	($Emitter2 as Node2D).scale = Vector2(1/scale.x, 1/scale.y)
	($Beam as Node2D).scale = Vector2(1/scale.x, 1)
	if(enabled):
		Enable()
	else:
		Disable()

func Disable():
	($Emitter.get_node("StaticBody2D/AnimatedSprite") as AnimatedSprite).frame = 1
	($Emitter2.get_node("StaticBody2D/AnimatedSprite") as AnimatedSprite).frame = 1
# warning-ignore:unsafe_method_access
	$Beam.hide()
	($Beam/CollisionShape2D as CollisionShape2D).set_disabled(true)
	

func Enable():
	($Emitter.get_node("StaticBody2D/AnimatedSprite") as AnimatedSprite).frame = 0
	($Emitter2.get_node("StaticBody2D/AnimatedSprite") as AnimatedSprite).frame = 0
# warning-ignore:unsafe_method_access
	$Beam.show()
	($Beam/CollisionShape2D as CollisionShape2D).set_disabled(false)
