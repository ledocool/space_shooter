extends Ship
class_name PlayerShip

func Load(data: Dictionary):
	set_sleeping(false)
	return .Load(data)


func _input(event):
	if event.is_action_pressed("shoot"):
		CannonFiring = true
	elif event.is_action_released("shoot"):
		CannonFiring = false
	
	if event.is_action_pressed("engine_fire"):
		EngineFiring = true
	elif event.is_action_released("engine_fire"):
		EngineFiring = false
		
	if event.is_action_pressed("wpn_1"):
		SwitchWeapon("slug")
	elif event.is_action_pressed("wpn_2"):
		SwitchWeapon("rocketeer")


func _physics_process(_delta):
	Cursor = get_global_mouse_position()	

