extends Ship
class_name PlayerShip

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("shoot"):
			CannonFiring = true
		elif event.is_action_released("shoot"):
			CannonFiring = false
		
		if event.is_action_pressed("engine_fire"):
			EngineFiring = true
		elif event.is_action_released("engine_fire"):
			EngineFiring = false

func _physics_process(_delta):
	Cursor = get_global_mouse_position()
	
