extends Node

 
onready var door = $"/root/Level/Scenery/Exit/BeamDoor"
onready var generator = $"/root/Level/Scenery/BelowHarvester/Lastroom/Wire/Wirerer7"
onready var lastwireGroup = get_tree().get_nodes_in_group("LastDoorWire")

var doorOpen = false

func _ready():
	for i in lastwireGroup:
		if(doorOpen):
			i.Disable()
		else:
			i.Enable()


func Save():
	return {
		"open": doorOpen
	}


func Load(data: Dictionary):
	doorOpen = data.open
	if(doorOpen):
		door.Disable()
		generator.Disable()
	else:
		door.Enable()
		generator.Enable()


func _on_Wirerer7_wire_switch(isOn):
	if(door && !isOn):
		for i in lastwireGroup:
			i.Disable()
		doorOpen = true
		door.call_deferred("Disable")
