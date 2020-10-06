extends Node

var topGeneratorOn = true
var bottomGeneratorOn = true

onready var topGenerator = $"/root/Level/Scenery/KeyRoom/Wires/KeyWirerTop"
onready var bottomGenerator = $"/root/Level/Scenery/KeyRoom/Wires/KeyWirererBottom"
onready var cageDoors = get_tree().get_nodes_in_group("cage_doors")
onready var bottomWires = get_tree().get_nodes_in_group("key_room_bottom_wire")
onready var bottomDoors = get_tree().get_nodes_in_group("key_room_bottom_door")
onready var topWires = get_tree().get_nodes_in_group("key_room_top_wire")
onready var topDoors = get_tree().get_nodes_in_group("key_room_left_door")

func Save():
	return {
		"topGeneratorOn": topGeneratorOn,
		"bottomGeneratorOn": bottomGeneratorOn
	}


func Load(data: Dictionary):
	topGeneratorOn = data.topGeneratorOn
	bottomGeneratorOn = data.bottomGeneratorOn


func _ready():
	if(topGeneratorOn):
		topGenerator.Enable()
	else:
		topGenerator.Disable()
	
	if(bottomGeneratorOn):
		bottomGenerator.Enable()
	else:
		bottomGenerator.Disable()	
		
	_switchTop(topGeneratorOn)
	_switchBottom(bottomGeneratorOn)


func _on_top_generator_switch(on: bool):
	topGeneratorOn = on
	_switchTop(topGeneratorOn)
	
	
func _on_bottom_generator_switch(on: bool):
	bottomGeneratorOn = on
	_switchBottom(bottomGeneratorOn)
	
	
func _switchBottom(isOn: bool):
	if(bottomDoors != null):
		for door in bottomDoors:
			if(isOn):
				door.call_deferred("Enable")
			else:
				door.call_deferred("Disable")
	
	if(bottomWires != null):
		for wire in bottomWires:
			if(isOn):
				wire.Enable()
			else:
				wire.Disable()
	
	if(cageDoors != null):
		for door in cageDoors:
			if(isOn):
				door.call_deferred("Enable")
			else:
				door.call_deferred("Disable")


func _switchTop(isOn: bool):
	if(topDoors != null):
		for door in topDoors:
			if(isOn):
				door.call_deferred("Enable")
			else:
				door.call_deferred("Disable")
	
	if(topWires):
		for wire in topWires:
			if(isOn):
				wire.Enable()
			else:
				wire.Disable()
