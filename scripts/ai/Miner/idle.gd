extends State

func _physics_process(_delta):
	if (target.IsNearPlayer() && target.IsSeesPlayer()):
		state_machine.transition("agitated")

# State machine callback called during transition when entering this state
func _on_enter_state(): 
	target.SetSpriteChill()
	pass

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	pass