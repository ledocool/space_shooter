extends State

func _physics_process(_delta):
	target.Track()


func _on_enter_state():
	target.StartShootCooldown()


func _on_leave_state(): 
	pass
