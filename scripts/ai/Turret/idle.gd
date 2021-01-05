extends State

var recheckTimer: Timer = Timer.new()

func _physics_process(_delta):
	if(target.Suspended):
		state_machine.transition("suspended")


func _on_enter_state():
	recheckTimer.wait_time = 1.0
	recheckTimer.autostart = true
	var _return = recheckTimer.connect("timeout", self, "_on_AreaRecheck")
	
	var targetArea: Area2D = target.get_node("Area2D")
	_return = targetArea.connect("body_entered", self, "_on_Area2D_body_entered")

# State machine callback called during transition when leaving this state
func _on_leave_state(): 
	var targetArea: Area2D = target.get_node("Area2D")
	targetArea.disconnect("body_entered", self, "_on_Area2D_body_entered")
	recheckTimer.disconnect("timeout", self, "_on_AreaRecheck")
	recheckTimer.stop()


func _on_AreaRecheck():
	var targetArea: Area2D = target.get_node("Area2D")
	var overlappingBodies = targetArea.get_overlapping_bodies()
	for body in overlappingBodies:
		_on_Area2D_body_entered(body)


func _on_Area2D_body_entered(body):
	if(body is PlayerShip):
		target.LockedTarget = weakref(body)
		state_machine.transition("track")
