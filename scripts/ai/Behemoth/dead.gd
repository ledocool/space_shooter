extends State

var Player: Ship = null
var Nav: Navigation2D = null

func _on_enter_state():
	target.CursorThrust = null
	target.linear_damp = target.LinearDamp
	target.angular_damp = target.AngularDamp
	target._onDeath()
	target.RemoveChamber()


func _on_leave_state():
	print("One cannot undie")


func _physics_process(_delta):
	pass
