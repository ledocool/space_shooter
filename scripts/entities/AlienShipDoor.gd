extends Node2D
class_name AlienShipDoor

var isClosed = true setget set_closed

func Save() -> Dictionary:
	return {
		"closed": isClosed
	}

func Load(data: Dictionary):
	isClosed = data.closed

func _ready():
	set_closed(false)

func set_closed(closed):
	isClosed = closed
	var mustDisable = !closed
	$alien_ship_door_top.visible = closed
	($Door/CollisionShape2D as CollisionShape2D).set_disabled(!closed)
	$Door/alien_ship_door_open.visible = !closed
	$Door/alien_ship_door_closed.visible = closed
	
