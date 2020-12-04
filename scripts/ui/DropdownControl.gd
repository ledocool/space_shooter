extends VBoxContainer
class_name DropdownControl

func SetLabelWidth(width):
	$Label.margin_right = width
	$Label.rect_size = Vector2(width, $Label.rect_size.y)

func SetItems(items):
	for item in items:
		$OptionButton.add_item(item)
