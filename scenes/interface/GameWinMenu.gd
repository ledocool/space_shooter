extends "res://scripts/ui/GameLoseMenu.gd"

func _on_Next_level_pressed():
	($"/root/LevelLoader" as LevelLoader).LoadNextLevel()
