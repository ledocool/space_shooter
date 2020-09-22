extends State

func _physics_process(_delta):
	pass
	
# State machine callback called during transition when entering this state
func _on_enter_state():
	if(target.IsPlayerVisible()):
		target.Shoot()
	else:
		target.SkipShoot()

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	pass
