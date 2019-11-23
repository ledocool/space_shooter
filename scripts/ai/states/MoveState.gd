extends "res://scripts/addon/state-machine/state.gd"

func _on_enter_state(): 
	print_debug("move")
	
func _on_leave_state(): pass

func _physics_process(delta):
	if(target.NeedEvade()):
		state_machine.transition("evasion")
		return
	if(target.TooFar()):
		state_machine.transition("move_closer")
		return
	if(target.TooClose()):
		state_machine.transition('move_away')
		return
	
	state_machine.transition("agitated")
	