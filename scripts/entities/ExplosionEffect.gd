extends Node2D

func _ready():
# warning-ignore:unsafe_method_access
	$AnimatedSprite.play()
	

func _on_AnimatedSprite_animation_finished():
	($AnimatedSprite as AnimatedSprite).stop()
	self.visible = false
	self.queue_free()


func _on_AudioStreamPlayer2D_finished():
	pass # Replace with function body.
