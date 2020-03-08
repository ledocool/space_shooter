extends Area2D


onready var hidesteroids = get_tree().get_nodes_in_group("LastRoomCoverup")

var hidden = false

func _on_LastroomRevealTrigger_body_entered(body):
	if(body is PlayerShip && !hidden):
		hidden = true
		for body in hidesteroids:
			body.Hide()
