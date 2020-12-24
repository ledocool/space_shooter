extends StaticBody2D

func _ready():
	pass # Replace with function body.

func Explodes():
	($AnimatedSprite as AnimatedSprite).play()
	($CollisionShape2D as CollisionShape2D).disabled = true
