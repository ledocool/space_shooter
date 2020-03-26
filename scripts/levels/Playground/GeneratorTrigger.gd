extends Node2D


onready var level
onready var hint

func _ready():
	level = get_node("/root/Level")
	hint = level.get_node("Scenery/IngameHint")

func _on_Wirerer_wire_switch(isOn):
	if(hint):
		hint.visible = isOn;
