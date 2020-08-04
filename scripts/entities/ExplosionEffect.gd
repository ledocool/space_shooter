extends Node2D

func _ready():
	$Particles2D.emitting = true
	$AnimatedSprite.play()

func _on_AnimatedSprite_animation_finished():
	($AnimatedSprite as AnimatedSprite).stop()
	self.visible = false
	self.queue_free()
