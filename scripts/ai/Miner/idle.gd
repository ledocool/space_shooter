extends State

func _physics_process(_delta):
	if(!target.IsOn()):
		state_machine.transition("off")

# State machine callback called during transition when entering this state
func _on_enter_state():
	target.SetSpriteChill()
	target.StartScanning()
	

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	target.StopScanning()
