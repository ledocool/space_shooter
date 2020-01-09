extends Control

signal save_game()
signal load_game()
signal options()

func _input(event):		
	if(event.is_action_pressed("ui_menu")):
		self.visible = !self.visible
		get_tree().paused = self.visible

func _exit_tree():
	get_tree().paused = false

func _on_Resume_pressed():
	self.visible = false
	get_tree().paused = false

func _on_Save_game_pressed():
	emit_signal("save_game")

func _on_Load_game_pressed():
	emit_signal("load_game")


func _on_Options_pressed():
	emit_signal("options")


func _on_Exit_pressed():
# warning-ignore:return_value_discarded
	($"/root/LevelLoader" as LevelLoader).LoadLevelByName("res://scenes/interface/MainMenu.tscn")
