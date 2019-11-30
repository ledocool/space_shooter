extends Node

onready var Level = self.get_parent().get_parent()
onready var ShipContainer = Level.get_node("ShipContainer/SleepingShips")

func _on_SlugPickup_picked_up(_data):
	if(Level):
		for ship in ShipContainer.get_children():
			ship.TurnOn()
