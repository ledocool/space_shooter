extends State

var Player: Ship = null
var Nav: Navigation2D = null
var FollowPath = null
var PathPointIndex = null

func _on_enter_state():
	Player = target.GetTarget()
	Nav = target.GetNavigator()
	if(Player != null && Nav != null):
		var calcCoords = Nav.get_closest_point(Player.GetCoordinates())
		
		FollowPath = Nav.get_simple_path(target.position, calcCoords)
		PathPointIndex = 0
	
func _on_exit_state():
	Player = null
	Nav = null
	FollowPath = null
	PathPointIndex = null
	target.Stop()

func _physics_process(_delta):
	if(target.CloseTo(Player.position)):
		state_machine.transition("stopping")
		return
	
	if(PathPointIndex == FollowPath.size()):
		state_machine.transition("stopping")
		return
		
	target.Thrust(FollowPath[PathPointIndex])
	
	if(target.CloseTo(FollowPath[PathPointIndex])):
		PathPointIndex += 1

