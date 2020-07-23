extends Collectable
class_name Gearpak

func _init():
	data.type = 1
	data.quantity = 1
	data.name = "healing"
	data.info = {
		"status": HealingStatus.new(),
		"popup_message": "Gearpak HP+"
	}
