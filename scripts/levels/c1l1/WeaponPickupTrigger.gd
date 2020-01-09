extends Node

onready var Level = $"/root/Level"

func _on_SlugPickup_picked_up(_data):
	if(Level):
		for ship in get_tree().get_nodes_in_group("SleepingShips"):
			ship.TurnOn()
