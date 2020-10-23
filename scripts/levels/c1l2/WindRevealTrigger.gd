extends Node

var shown = false
onready var windParticles = get_tree().get_nodes_in_group("wind")


func _ready():
	if(shown):
		ShowWind()


func Save():
	return {
		"wind_shown": shown
	}


func Load(data: Dictionary):
	shown = data.wind_shown


func ShowWind():
	for particle in windParticles:
		particle.visible = true


func _on_KeyPickup_picked_up(_data):
	shown = true
	ShowWind()
