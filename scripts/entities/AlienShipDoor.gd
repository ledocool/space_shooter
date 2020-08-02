extends Node2D
class_name AlienShipDoor

export var isClosed = true setget set_closed

func Save() -> Dictionary:
	return {
		"closed": isClosed
	}

func Load(data: Dictionary):
	isClosed = data.closed

func _ready():
	set_closed(isClosed)

func playDoorAnimation(closing: bool):
	($Door/AnimatedSprite as AnimatedSprite).play("", closing)
	if closing:
		($Door/AnimatedSprite as Node2D).z_index = 8
	else:
		($Door/AnimatedSprite as Node2D).z_index = -1

func set_closed(closed):
	isClosed = closed
	if(isClosed):
		($alien_ship_door_top as Hideable).Show()
	else:
		($alien_ship_door_top as Hideable).Hide()
	
	($Door/CollisionShape2D as CollisionShape2D).call_deferred("set_disabled", !closed)
	playDoorAnimation(closed)
	


func _on_Area2D_body_entered(_body):
	set_closed(!isClosed)
