extends Control
	
func _on_Exit_pressed():
	get_tree().quit()

func _on_Playground_pressed():
	($"/root/LevelLoader" as LevelLoader).LoadLevelByName("res://scenes/levels/Playground.tscn")

func _on_New_game_pressed():
	($"/root/LevelLoader" as LevelLoader).LoadLevel(0)
	