extends State

var Player: Ship = null
var Nav: Navigation2D = null

func _on_enter_state():
	Player = target.GetTarget()
	Nav = target.GetNavigator()
	
func _on_exit_state():
	pass

func _physics_process(_delta):
	if(Player != null && Nav != null):
		state_machine.transition("agitated")
