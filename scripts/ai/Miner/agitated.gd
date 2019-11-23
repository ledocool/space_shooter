extends State

func _physics_process(_event):
	var localPlayer = target.GetPlayer()
	if(!localPlayer):
		return;
	
	if (target.IsNearPlayer(localPlayer)):
		target.TrackPlayer(localPlayer)
	else:
		state_machine.transition("idle")
	

# State machine callback called during transition when entering this state
func _on_enter_state():
	target.EngineFiring = true
	target.SetSpriteAngry()
	pass

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	target.EngineFiring = false
	pass