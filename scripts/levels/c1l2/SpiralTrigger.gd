extends Node

var horizontalOpened = true
var verticalOpened = false

onready var generator = $"/root/Level/Scenery/Spiral/InspiralGenerator"
onready var wires = get_tree().get_nodes_in_group("inspiral_wire")
onready var horizontalDoors = get_tree().get_nodes_in_group("spiral_horizontal_doors")
onready var verticalDoors = get_tree().get_nodes_in_group("spiral_vertical_doors")

func Save():
	return {
		"horizontalOpened": horizontalOpened,
		"verticalOpened": verticalOpened
	}


func Load(data: Dictionary):
	horizontalOpened = data.horizontalOpened
	verticalOpened = data.verticalOpened


func _ready():
	generator.emitSignals = false
	if(generatorOn()):
		generator.Enable()
	else:
		generator.Disable()
		
	generator.emitSignals = true
	
	_switchHorizontal(!horizontalOpened)
	_switchVertical(!verticalOpened)
	_switchWires(generatorOn())


func _switchHorizontal(isOn: bool):
	if(horizontalDoors != null):
		for door in horizontalDoors:
			if(isOn):
				door.call_deferred("Enable")
			else:
				door.call_deferred("Disable")


func _switchVertical(isOn: bool):
	if(verticalDoors != null):
		for door in verticalDoors:
			if(isOn):
				door.call_deferred("Enable")
			else:
				door.call_deferred("Disable")


func _switchWires(isOn: bool):
	if(wires != null):
		for wire in wires:
			if(isOn):
				wire.Enable()
			else:
				wire.Disable()


func generatorOn():
	return horizontalOpened == true && verticalOpened == false


func _on_InspiralGenerator_wire_switch(isOn):
	horizontalOpened = false
	verticalOpened = true
	_switchHorizontal(!horizontalOpened)
	_switchVertical(!verticalOpened)
	_switchWires(generatorOn())



func _on_KeyPickup_picked_up(data):
	horizontalOpened = true
	_switchHorizontal(!horizontalOpened)
