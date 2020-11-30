extends Collectable

func _init():
	data.type = 3
	data.quantity = 1
	data.name = "cube"
	data.info = {
		"popup_message": tr("the_odd_cube"),
		"class": "res://scenes/entities/ConcreteEntities/Collectable/KeyCube.tscn"
	}
