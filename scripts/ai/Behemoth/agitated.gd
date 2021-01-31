extends State

var nav: Navigation2D
var player: Ship

func _on_enter_state():
	print("agitated")
	nav = target.GetNavigator()
	target.TurretsEnable(true)
	player = target.GetTarget()


func _on_leave_state():
	target.TurretsEnable(false)


func _physics_process(_delta):
	var tHealth = target.GetPowerNodeBottomHealth() + target.GetPowerNodeTopHealth()
		
	if(tHealth == 0):
		state_machine.transition("dead")
		return
	
	var closestPoint = nav.get_closest_point(player.get_global_position())
	var distanceTo = closestPoint - target.get_global_position()
	
	if(target.FarFromDist(distanceTo.length()) && target.FarFrom(target.GetTarget())):
		state_machine.transition("pursue")
		return

