extends Area2D

var alienDoorOpened = false
onready var AlienDoor = $"/root/Level/Scenery/Exit/AlienShipDoor"

func Load(data: Dictionary):
	alienDoorOpened = data.alienDoor


func Save():
	return {
		"alienDoor": AlienDoor.isClosed
	}


func _ready():
	AlienDoor.isClosed = !alienDoorOpened


func openDeferred(body: KeyCube):
	body.Destroy()
	AlienDoor.isClosed = false


func _on_DoorOpenTrigger_body_entered(body):
	if body is KeyCube:
		call_deferred("openDeferred", body)
