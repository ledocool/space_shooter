extends Control

signal pressed()


func _ready():
# warning-ignore:unsafe_property_access
	#self.rect_size = $CloseButton.rect_size
	#self.rect_min_size = Vector2(150, 22)
	pass

func _on_CloseButton_pressed():
	# warning-ignore:unsafe_method_access
	$PressSound.play()

func _on_PressSound_finished():
	emit_signal("pressed")

