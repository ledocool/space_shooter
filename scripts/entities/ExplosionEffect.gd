extends Node2D

func _ready():
# warning-ignore:unsafe_method_access
	$AnimatedSprite.play()


func Save() -> Dictionary:
	return {
		"position": position,
		"size": scale
	}


func Load(data: Dictionary):
	var pos = data.position.trim_prefix('(').trim_suffix(')').split(',')
	self.position = Vector2(pos[0], pos[1])
	var sc = data.size.trim_prefix('(').trim_suffix(')').split(',')
	self.scale = Vector2(sc[0], sc[1])


func _on_AnimatedSprite_animation_finished():
	($AnimatedSprite as AnimatedSprite).stop()
	self.visible = false
	self.queue_free()


func _on_AudioStreamPlayer2D_finished():
	pass # Replace with function body.
