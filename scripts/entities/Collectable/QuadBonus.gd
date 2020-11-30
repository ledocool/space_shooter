extends Collectable

func _init():
	data.type = 1
	data.quantity = 1
	data.name = "berzerk"
	data.info = {
		"status": QuadDamageStatus.new(),
		"popup_message": tr("quad_damage")
	}
