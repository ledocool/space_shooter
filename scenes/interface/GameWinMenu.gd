extends "res://scripts/ui/GameLoseMenu.gd"

func _on_Next_level_pressed():
	var currentLevel = $"/root/Level" as Level
	($"/root/LevelLoader" as LevelLoader).LoadNextLevel()
