extends State

var Player: Ship = null
var Nav = null
var FollowPath = null
var PathPointIndex = null
var FollowPathPointNodes = null

func _on_enter_state():
	target.ForwardJets(true)

	Player = target.GetTarget()
	Nav = target.GetNavigator()
	PathPointIndex = 0
	if(Player != null && Nav != null):
		var calcCoords = Nav.get_closest_point(Player.GetCoordinates())
		FollowPath = Nav.get_simple_path(target.position, calcCoords)
		FollowPathPointNodes = Nav.get_check_areas()


func _on_leave_state():
	target.ForwardJets(false)
	target.LeftJets(false)
	target.RightJets(false)
	
	Nav.purge_areas()
	for point in FollowPathPointNodes:
		point.queue_free()
	FollowPathPointNodes = null	
	Player = null
	Nav = null
	FollowPath = null
	PathPointIndex = null


func _physics_process(_delta):
	var tHealth = target.GetPowerNodeBottomHealth() + target.GetPowerNodeTopHealth()
	if(tHealth == 0):
		state_machine.transition("dead")
		return
	
	if(target.CloseTo(Player)):
		state_machine.transition("stop")
		return
	
	if(PathPointIndex >= FollowPath.size()):
		state_machine.transition("stop")
		return
		
	target.Thrust(FollowPath[PathPointIndex])
	
	if(target.CloseToPos(FollowPathPointNodes[PathPointIndex])):
		PathPointIndex += 1
