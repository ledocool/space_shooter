extends "res://scripts/addon/state-machine/state.gd"

const AgitatedStateTimeout = 0.1
var AgitatedStateCooldown = 0

func _on_enter_state():
	AgitatedStateCooldown = AgitatedStateTimeout
	print_debug("agitated")
	
func _on_exit_state():
	pass

func _physics_process(delta):
	if(AgitatedStateCooldown > 0):
		AgitatedStateCooldown -= delta
		return
#	if(target.ActionCooldown > 0):
#		state_machine.transition("waste_time")
#		return
		
	if(target.NeedMove()):
		state_machine.transition("move")
		return
		
	if(!target.SeesEnemy()):
		state_machine.transition("stand_by")
		return
		
	if(target.CanShoot()):
		state_machine.transition("aim")
		return
		
	
	
