extends Control

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Exit_pressed():
	$"/root/LevelLoader".LoadLevelByName("res://scenes/interface/MainMenu.tscn")

func _on_Retry_pressed():
	$"/root/LevelLoader".ReloadLevel()
