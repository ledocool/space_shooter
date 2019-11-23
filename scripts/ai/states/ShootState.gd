extends "res://scripts/addon/state-machine/state.gd"

func _on_enter_state():
	target.Shoot()
	pass
	
func _on_leave_state():
	target.StopShooting()
	pass

func _physics_process(delta):
	state_machine.transition("agitated")