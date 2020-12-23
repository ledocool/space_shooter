extends "res://scripts/addon/state-machine/state.gd"

func _on_enter_state(): 
	print_debug("move_away")
	pass

func _on_leave_state(): pass

func _physics_process(delta): 
	target.MoveAway()
	state_machine.transition("agitated")
	
