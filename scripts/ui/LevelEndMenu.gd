extends Control

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Exit_pressed():
	var changed = get_tree().change_scene("res://scenes/interface/MainMenu.tscn")
	print_debug("Exit: " + String(changed))
	

func _on_Retry_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
