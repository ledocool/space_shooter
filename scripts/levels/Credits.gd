extends Control

onready var LevelMan = $"/root/LevelLoader"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if(event.is_action_pressed("ui_menu")):
		GoToMainMenu()


func GoToMainMenu():
	LevelMan.LoadLevelByName("res://scenes/interface/MainMenu.tscn", false)


func _on_RemoveTimer_timeout():
	GoToMainMenu()
