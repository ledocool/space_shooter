extends Area2D

func _on_Collectable_body_entered(body):
	if(body.has_method("Pickup")):
		body.Pickup(self);
