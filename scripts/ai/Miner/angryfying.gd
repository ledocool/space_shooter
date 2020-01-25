extends State

func _physics_process(_event):
	if (target.get_node("Timers/AngryfyingTimer").is_stopped()):
		state_machine.transition("agitated")
	
func _on_enter_state():
	target.get_node("Timers/AngryfyingTimer").start()
	target.get_node("Timers/AngryfyingBlinkTimer").start()

func _on_leave_state(): 
	target.get_node("Timers/AngryfyingBlinkTimer").stop()