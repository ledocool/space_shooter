extends Node

onready var Level = $"/root/Level"

onready var Ships = get_tree().get_nodes_in_group("SleepingShips")

func _on_SlugPickup_picked_up(_data):
	if(Level):
		for ship in Ships:
			ship.TurnOn()
