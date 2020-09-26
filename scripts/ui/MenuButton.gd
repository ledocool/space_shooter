tool
extends Control

signal pressed_named(text)
signal pressed()

export var Text: String = "Menu Button"
export var disabled: bool setget set_disabled,get_disabled


func _ready():
# warning-ignore:unsafe_property_access
	self.rect_size = $MenuButton.rect_size
	self.rect_min_size = Vector2(150, 22)
# warning-ignore:unsafe_property_access
	$MenuButton.text = Text


func _on_MenuButton_pressed():
# warning-ignore:unsafe_method_access
	$PressSound.play()


func _on_PressSound_finished():
# warning-ignore:unsafe_property_access
# warning-ignore:unsafe_property_access
	emit_signal("pressed_named", $MenuButton.text)
	emit_signal("pressed")


func set_disabled(value):
# warning-ignore:unsafe_property_access
	$MenuButton.disabled = value


func get_disabled():
# warning-ignore:unsafe_property_access
	return $MenuButton.disabled
