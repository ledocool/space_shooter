extends State

func _on_enter_state():
	print("agitated")
	target.TurretsEnable(true)


func _on_leave_state():
	target.TurretsEnable(false)


func _physics_process(_delta):
	var tHealth = target.GetPowerNodeBottomHealth() + target.GetPowerNodeTopHealth()
	if(tHealth == 0):
		state_machine.transition("dead")
		return
	
	if(target.FarFrom(target.GetTarget())):
		state_machine.transition("pursue")
		return

