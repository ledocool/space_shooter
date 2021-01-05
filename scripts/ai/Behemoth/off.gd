extends State

var Player: Ship = null
var Nav: Navigation2D = null

func _on_enter_state():
	print("off")


func _on_leave_state():
	pass


func _physics_process(_delta):
	Player = target.GetTarget()
	Nav = target.GetNavigator()
	
	if(Player != null && Nav != null):
		state_machine.transition("agitated")
