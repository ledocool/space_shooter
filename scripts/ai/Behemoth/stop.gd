extends State


func _on_enter_state():
	target.CursorThrust = null
	target.linear_damp = target.LinearDamp
	target.angular_damp = target.AngularDamp


func _on_leave_state():
	target.linear_damp = -1
	target.angular_damp = -1


func _physics_process(_delta):
	var tHealth = target.GetPowerNodeBottomHealth() + target.GetPowerNodeTopHealth()
	if(tHealth == 0):
		state_machine.transition("dead")
		return
	
	if(target.IsStationary()):
		state_machine.transition("agitated")
		return
