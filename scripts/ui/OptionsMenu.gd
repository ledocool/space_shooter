extends Control


func _on_CloseButton_pressed():
	self.visible = false


func _unhandled_key_input(event):
	if(event.is_action_pressed("ui_menu")):
		if(self.visible):
			get_tree().set_input_as_handled()
		self.visible = false
