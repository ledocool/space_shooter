extends State

func _physics_process(_delta):
	if(target.Suspended):
		state_machine.transition("suspended")
		return
	target.Track()


func _on_enter_state():
	target.StartShootCooldown()
	var shootCooldown = target.get_node("Timers/ShootCooldown")
	shootCooldown.connect("timeout", self, "_on_ShootCooldown_timeout")
	var targetArea: Area2D = target.get_node("Area2D")
	
	var playerInRange = false
	for body in targetArea.get_overlapping_bodies():
		if(body is PlayerShip):
			playerInRange = true
	
	if(!playerInRange):
		state_machine.transition("idle")
	
	targetArea.connect("body_exited", self, "_on_Area2D_body_exited")

func _on_leave_state():
	var shootCooldown = target.get_node("Timers/ShootCooldown")
	shootCooldown.disconnect("timeout", self, "_on_ShootCooldown_timeout")
	var targetArea: Area2D = target.get_node("Area2D")
	targetArea.disconnect("body_exited", self, "_on_Area2D_body_exited")
	

func _on_ShootCooldown_timeout():
	state_machine.transition("shoot")


func _on_Area2D_body_exited(body):
	if target.GetTarget() && body == target.GetTarget():
		target.LockedTarget = null
		state_machine.transition("idle")
