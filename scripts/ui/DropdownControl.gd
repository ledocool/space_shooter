tool
extends Control
class_name DropdownControl

signal item_selected(id)

export var LabelText = "text"

func _ready():
# warning-ignore:unsafe_property_access
	$WindowModeContainer/Label.text = tr(LabelText)

func SetItems(items):
	for item in items:
# warning-ignore:unsafe_method_access
		$WindowModeContainer/OptionButton.add_item(item)


func SetSelected(index):
# warning-ignore:unsafe_method_access
	$WindowModeContainer/OptionButton.select(index)

func _on_OptionButton_item_selected(id):
	emit_signal("item_selected", id)
