extends Area2D
class_name Collectable

var data = Pickup.new()

func _on_Collectable_body_entered(body):
	if(body.has_method("Pickup")):
		if(body.Pickup(data)):
			visible = false
			queue_free()
