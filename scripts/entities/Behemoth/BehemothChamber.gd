extends StaticBody2D

func _ready():
	pass # Replace with function body.

func Explodes():
	$AnimatedSprite.play()
	$CollisionShape2D.disabled = true
