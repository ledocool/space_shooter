extends State

func _physics_process(_delta):
	pass
	
# State machine callback called during transition when entering this state
func _on_enter_state():
	var blowupCooldown: Timer = target.get_node("Timers/ShootBlowupCooldown")
	blowupCooldown.call_deferred("connect", "timeout", self, "_on_ShootBlowupCooldown_timeout")
	if(target.IsPlayerVisible()):
		target.Shoot()
	else:
		state_machine.transition("track")

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	var blowupCooldown: Timer = target.get_node("Timers/ShootBlowupCooldown")
	blowupCooldown.call_deferred("disconnect", "timeout", self, "_on_ShootBlowupCooldown_timeout")


func _on_ShootBlowupCooldown_timeout():
	state_machine.transition("track")
