extends State


func _on_enter_state():
	target.TurretsEnable(false)
	for turret in target.get_node("Turrets").get_children():
		if(turret is Turret):
			turret.connect("health_changed", self, "_on_first_damage")
			
	for node in target.get_node("Power").get_children():
		if(node is PowerNode):
			node.connect("health_changed", self, "_on_first_damage")


func _on_leave_state():
	for turret in target.get_node("Turrets").get_children():
		if(turret is Turret):
			turret.disconnect("health_changed", self, "_on_first_damage")
			
	for node in target.get_node("Power").get_children():
		if(node is PowerNode):
			node.disconnect("health_changed", self, "_on_first_damage")


func _physics_process(_delta):
	pass
		

func _on_first_damage(oldHealth, newHealth):
	if(newHealth - oldHealth < 0 \
	&& target.GetTarget() != null \
	&& target.GetNavigator() != null):
		state_machine.transition("agitated")
