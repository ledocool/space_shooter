extends State

func _physics_process(_delta):
	pass


func _on_enter_state():
	target._on_dead()


func _on_leave_state(): 
	pass
