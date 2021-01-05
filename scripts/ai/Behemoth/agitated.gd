extends State


func _on_enter_state():
	print("agitated")
	target.TurretsEnable(true)


func _on_leave_state():
	target.TurretsEnable(false)


func _physics_process(_delta):
	var tHealth = target.GetPowerNodeBottomHealth() + target.GetPowerNodeTopHealth()
	var shouldEvade = \
		float(tHealth) / target.GetPowerNodeMaxHealth() < target.GetBehaviourChangeThreshold()
	
	if(shouldEvade && target.CloseTo(target.GetTarget())):
		state_machine.transition("evade")
	if(!shouldEvade && target.FarFrom(target.GetTarget())):
		state_machine.transition("pursue")

