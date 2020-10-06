extends Area2D

var alienDoorOpened = false
onready var AlienDoor = $"/root/Level/Scenery/StartingRoom/AlienShipDoor"

func Load(data: Dictionary):
	alienDoorOpened = data.alienDoor


func Save():
	return {
		"alienDoor": alienDoorOpened
	}


func _ready():
	AlienDoor.isClosed = !alienDoorOpened


func _on_AlienDoorTrigger_body_entered(body):
	if body is KeyCube:
		call_deferred("openDeferred", body)


func openDeferred(body: KeyCube):
	body.Destroy()
	AlienDoor.isClosed = false

