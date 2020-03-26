extends State

func _physics_process(_event):
	if (target.IsOn()):
		state_machine.transition("idle")
	
# State machine callback called during transition when entering this state
func _on_enter_state():
	target.SetSpriteChill()
	target.SetAiTimersTicking(false)
	target.EngineFiring = false
	pass

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	target.SetAiTimersTicking(true)
	pass
