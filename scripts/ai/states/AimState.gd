extends "res://scripts/addon/state-machine/state.gd"

func _on_enter_state():
	print_debug("aim")
	pass
	
func _on_exit_state():
	pass

func _physics_process(delta):
	if(target.Aim()):
		state_machine.transition("shoot")
	else:
		state_machine.transition("agitated")