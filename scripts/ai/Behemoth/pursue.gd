extends State

var Player: Ship = null
var Nav = null
var FollowPath = null
var PathPointIndex = null
var FollowPathPointNodes = null


func _on_enter_state():
	print("pursue")
	Player = target.GetTarget()
	Nav = target.GetNavigator()
	PathPointIndex = 0
	if(Player != null && Nav != null):
		var calcCoords = Nav.get_closest_point(Player.GetCoordinates())
		FollowPath = Nav.get_simple_path(target.position, calcCoords)
		FollowPathPointNodes = Nav.get_check_areas()


func _on_leave_state():
	Nav.purge_areas()
	for point in FollowPathPointNodes:
		point.queue_free()
	FollowPathPointNodes = null	
	Player = null
	Nav = null
	FollowPath = null
	PathPointIndex = null


func _physics_process(_delta):
	if(target.CloseTo(Player)):
		state_machine.transition("stop")
		return
	
	if(PathPointIndex >= FollowPath.size()):
		state_machine.transition("stop")
		return
		
	target.Thrust(FollowPath[PathPointIndex])
	
	if(target.CloseToPos(FollowPathPointNodes[PathPointIndex])):
		PathPointIndex += 1
