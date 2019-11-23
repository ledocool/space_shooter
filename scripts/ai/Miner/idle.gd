extends State

func _physics_process(_delta):
	var localPlayer = target.GetPlayer()
	if(!localPlayer):
		return;
	if (target.IsNearPlayer(localPlayer) && target.IsSeesPlayer(localPlayer)):
		state_machine.transition("agitated")

# State machine callback called during transition when entering this state
func _on_enter_state(): 
	target.SetSpriteChill()
	pass

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	pass