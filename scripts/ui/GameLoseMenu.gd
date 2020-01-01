extends Control

func _on_Retry_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_Exit_pressed():
	var changed = get_tree().change_scene("res://scenes/interface/MainMenu.tscn")
	print_debug("Exit: " + String(changed))

func SetData(data: Dictionary):
	var stats = self.find_node("Statistics")
	for stat in stats.get_children():
		var name = stat.get_name()
		var value = data.get(name, "")
		var val_node = stat.get_node("value") 
		val_node.text = String(value)

func _on_MenuBoard_visibility_changed():
	get_tree().paused = self.visible
