extends Node

 
onready var door = $"/root/Level/Scenery/BelowHarvester/BuildIntersection/BeamDoorMid"
onready var generator = $"/root/Level/Scenery/BelowHarvester/BuildIntersection/Wirerer"
var doorOpen = false

func _ready():
	if(doorOpen):
		door.Disable()
		generator.Disable()
	else:
		door.Enable()
		generator.Enable()


func Save():
	return {
		"belowHarvesterDoorOpen": doorOpen
	}


func Load(data: Dictionary):
	doorOpen = data.belowHarvesterDoorOpen
	


func _on_Wirerer_wire_switch(isOn):
	if(door && !isOn):
		doorOpen = true
		door.call_deferred("Disable")
