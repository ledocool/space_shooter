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
	
	var tHealth = target.GetPowerNodeBottomHealth() + target.GetPowerNodeTopHealth()
	if(tHealth == 0):
		state_machine.transition("dead")
		return
	
	if(Player != null && Nav != null):
		state_machine.transition("agitated")
		return
