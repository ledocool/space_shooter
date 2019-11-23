extends Control

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
	pass # Replace with function body.


func _on_Load_game_pressed():
	pass # Replace with function body.


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	var changed = get_tree().change_scene("res://scenes/interface/MainMenu.tscn")
	print_debug("New game: " + String(changed))
