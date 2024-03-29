tool
extends Control
class_name SliderControl

export var LabelText = "text"
export var SliderMax = 1
export var SliderMin = 0.0001
export var SliderDefault = 0
export var SliderStep = 0.001

signal value_changed(newValue)

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:unsafe_property_access
	$VBoxContainer/Label.text = LabelText
# warning-ignore:unsafe_property_access
	$VBoxContainer/HSlider.max_value = SliderMax
# warning-ignore:unsafe_property_access
	$VBoxContainer/HSlider.min_value = SliderMin
# warning-ignore:unsafe_property_access
	$VBoxContainer/HSlider.value = SliderDefault
# warning-ignore:unsafe_property_access
	$VBoxContainer/HSlider.step = SliderStep

func SetSliderValue(value):
# warning-ignore:unsafe_property_access
	$VBoxContainer/HSlider.value = value

func _on_HSlider_value_changed(value):
	emit_signal("value_changed", value)
