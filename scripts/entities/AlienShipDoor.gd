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

func playDoorAnimation(closing: bool):
	($Door/AnimatedSprite as AnimatedSprite).play("", closing)
	if closing:
		($Door/AnimatedSprite as Node2D).z_index = 8
	else:
		($Door/AnimatedSprite as Node2D).z_index = -1

func set_closed(closed):
	isClosed = closed
	($alien_ship_door_top as Node2D).visible = closed
	($Door/CollisionShape2D as CollisionShape2D).set_disabled(!closed)
	playDoorAnimation(closed)
	
