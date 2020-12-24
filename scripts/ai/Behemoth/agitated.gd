extends State

func _on_enter_state():
	target.TurretsEnable()
	
func _on_exit_state():
	target.TurretsEnable("false")

func _physics_process(_delta):
	var shouldEvade = target.GetHealth() / target.GetMaxGealth() < target.GetBehaviourChangeThreshold()
	var targetPosition = target.GetTarget().position
	
	if(shouldEvade && target.CloseTo(targetPosition)):
		state_machine.transition("evade")
	if(!shouldEvade && target.FarFrom(targetPosition)):
		state_machine.transition("pursue")

