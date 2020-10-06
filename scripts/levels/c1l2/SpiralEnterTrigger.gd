extends Node

var opened = false

onready var generator = $"/root/Level/Scenery/StartingRoom/Building/SpiralGenerator"
onready var wires = get_tree().get_nodes_in_group("spiral_entrance_wire")
onready var door = $"/root/Level/Scenery/StartingRoom/Building/SpiralEntrance"

func Save():
	return {
		"opened": opened
	}


func Load(data: Dictionary):
	opened = data.opened


func _ready():
	if(!opened):
		generator.Enable()
	else:
		generator.Disable()

	_switch(!opened)


func _switch(isOn: bool):
	if(door != null):
		if(isOn):
			door.call_deferred("Enable")
		else:
			door.call_deferred("Disable")
	
	if(wires != null):
		for wire in wires:
			if(isOn):
				wire.Enable()
			else:
				wire.Disable()


func _on_SpiralGenerator_wire_switch(isOn):
	opened = !isOn
	_switch(!opened)
