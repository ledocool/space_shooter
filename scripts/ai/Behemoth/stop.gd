extends State


func _on_enter_state():
	print("stop")
	target.CursorThrust = null
	target.linear_damp = target.LinearDamp
	target.angular_damp = target.AngularDamp


func _on_leave_state():
	target.linear_damp = -1
	target.angular_damp = -1


func _physics_process(_delta):
	if(target.IsStationary()):
		state_machine.transition("agitated")
