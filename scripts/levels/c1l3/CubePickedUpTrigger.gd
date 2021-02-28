extends Node

var CubePickedUp = false
onready var Lights = get_tree().get_nodes_in_group("lights")
onready var Wind = get_tree().get_nodes_in_group("space_wind")
# warning-ignore:unsafe_method_access
var BehemothInstance

func Save():
	return {
		"cube_picked_up": CubePickedUp
	}


func Load(data: Dictionary):
	CubePickedUp = data.cube_picked_up


func _ready():
	BehemothInstance = $"/root/Level/ShipContainer".get_node_or_null("Behemoth")
	if !BehemothInstance.is_connected("cube_picked_up", self, "_on_Behemoth_cube_picked_up"):
		BehemothInstance.connect("cube_picked_up", self, "_on_Behemoth_cube_picked_up")
	if CubePickedUp:
		removeLights()
		enableWind()


func removeLights():
	for lightBundle in Lights:
		for light in lightBundle.get_children():
			light.Stop()


func enableWind():
	for w in Wind:
# warning-ignore:unsafe_cast
		var wnd = w as Node2D
		if wnd:
			wnd.visible = true


func _on_Behemoth_cube_picked_up(_data):
	removeLights()
	enableWind()
	CubePickedUp = true
