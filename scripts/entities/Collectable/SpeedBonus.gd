extends Collectable

func _init():
	data.type = 1
	data.quantity = 1
	data.name = "berzerk"
	data.info = {
		"status": SpeedupStatus.new()
	}
