extends Control
	
func _on_Exit_pressed():
	get_tree().quit()

func _on_Playground_pressed():
	var changed = get_tree().change_scene("res://scenes/levels/Playground.tscn")
	print_debug("Playground: " + String(changed))

func _on_New_game_pressed():
	var changed = get_tree().change_scene("res://scenes/levels/c1l1.tscn")
	print_debug("New game: " + String(changed))
	