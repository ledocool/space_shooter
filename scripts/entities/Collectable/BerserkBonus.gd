extends Collectable
class_name BerserkBonus


func _init():
	data.type = 1
	data.quantity = 1
	data.name = "berzerk"
	data.info = {
		"status": BerserkStatus.new(),
		"popup_message": "berserk"
	}
