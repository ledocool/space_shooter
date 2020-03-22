extends Area2D


onready var hidesteroids = get_tree().get_nodes_in_group("LastRoomCoverup")

var hidden = false

func _ready():
	if(hidden):
		for body in hidesteroids:
			body.Hide()
			body.hide()


func Save() -> Dictionary:
	return {
		"lastroomHidden": hidden
	}


func Load(data: Dictionary):
	hidden = data.lastroomHidden


func _on_LastroomRevealTrigger_body_entered(body):
	if(hidden == false && body is PlayerShip):
		hidden = true
		for body in hidesteroids:
			body.Hide()
