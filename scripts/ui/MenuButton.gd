extends Button

signal pressed_named(text)

func _on_MenuButton_pressed():
	emit_signal("pressed_named", self.text)
