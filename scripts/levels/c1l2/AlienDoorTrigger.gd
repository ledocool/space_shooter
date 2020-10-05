extends Area2D

onready var AlienDoor = $"/root/Level/Scenery/StartingRoom/AlienShipDoor"

func Load(data: Dictionary):
	AlienDoor.Load(data.alienDoor)


func Save():
	return {
		"alienDoor": AlienDoor.Save()
	}


func _on_AlienDoorTrigger_body_entered(body):
	if body is KeyCube:
		call_deferred("openDeferred", body)


func openDeferred(body: KeyCube):
	body.Destroy()
	AlienDoor.isClosed(false)

