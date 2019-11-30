extends Node

onready var Level = self.get_parent().get_parent() as Node

func _on_SlugPickup_picked_up(_data):
	if(Level):
		var SleepersContainer = Level.get_node("ShipContainer/SleepingShips") as Node
		for ship in SleepersContainer.get_children():
			(ship as Miner).TurnOn()
