extends Control

var playerData = null

func _on_Retry_pressed():
	($"/root/LevelLoader" as LevelLoader).ReloadLevel()

func _on_Exit_pressed():
	($"/root/LevelLoader" as LevelLoader).LoadLevelByName("res://scenes/interface/MainMenu.tscn")

func SetData(data: Dictionary, playerData: Dictionary):
	var stats = self.find_node("Statistics")
	self.playerData = playerData
	for stat in stats.get_children():
		var name = stat.get_name()
		var value = data.get(name, "")
		var val_node = stat.get_node("value") 
		val_node.text = String(value)

func _on_MenuBoard_visibility_changed():
	get_tree().paused = self.visible
