extends Node2D

func _ready():
# warning-ignore:unsafe_property_access
	$Particles2D.emitting = true
# warning-ignore:unsafe_method_access
	$AnimatedSprite.play()

func _on_AnimatedSprite_animation_finished():
	($AnimatedSprite as AnimatedSprite).stop()
	self.visible = false
	self.queue_free()
