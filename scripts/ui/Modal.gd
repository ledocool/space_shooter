extends Popup


func _unhandled_key_input(event):
	if(event.is_action_pressed("ui_menu")):
		if(self.visible):
			self.hide()
			get_tree().set_input_as_handled() 


func Show(text: String, size: Vector2 = Vector2(500,240)):
# warning-ignore:unsafe_property_access
	find_node("RichTextLabel").text = text
	popup_centered(size)


func _on_Ok_pressed():
	self.hide()
