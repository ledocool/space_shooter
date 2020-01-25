extends State

func _physics_process(_delta):
	if(!target.IsOn()):
		state_machine.transition("off")
			
	if (target.IsNearPlayer() && target.IsSeesPlayer()):
		state_machine.transition("angryfying")

# State machine callback called during transition when entering this state
func _on_enter_state(): 
	target.SetSpriteChill()
	pass

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	pass