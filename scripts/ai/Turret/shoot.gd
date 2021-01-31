extends State

var actionTaken = false

func _physics_process(_delta):
	if(!actionTaken):
		actionTaken = true
		if(target.IsPlayerVisible()):
			target.Shoot()
		else:
			target.SkipShoot()
	
# State machine callback called during transition when entering this state
func _on_enter_state():
	actionTaken = false

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	pass
