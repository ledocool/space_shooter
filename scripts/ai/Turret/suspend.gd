extends State


func _physics_process(_delta):
	if(target.Suspended == false):
		state_machine.transition("idle")
	
# State machine callback called during transition when entering this state
func _on_enter_state():
	pass

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	pass
