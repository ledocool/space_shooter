extends StaticBody2D
class_name KeyChamber

func _ready():
	pass # Replace with function body.

func Explodes():
	($AnimatedSprite as AnimatedSprite).play()
	($CollisionShape2D as CollisionShape2D).call_deferred("set_disabled", true)
	
func Exploded():
	($CollisionShape2D as CollisionShape2D).call_deferred("set_disabled", true)
	($AnimatedSprite as AnimatedSprite).frame = 10
