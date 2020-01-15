extends Area2D
class_name Collectable

signal picked_up (data)

var data = Pickup.new()

func _on_Collectable_body_entered(body):
	if(body.has_method("Pickup")):
		if(body.Pickup(data)):
			visible = false
			emit_signal("picked_up", data)
			queue_free()

func Save():
	return {
		"position": position
	}
	
func Load(data: Dictionary):
	var pos = data.position.trim_prefix('(').trim_suffix(')').split(',')
	position = Vector2(pos[0], pos[1])