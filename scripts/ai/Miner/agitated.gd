extends State

func _physics_process(_event):
	if(!target.IsOn()):
		state_machine.transition("off")

# State machine callback called during transition when entering this state
func _on_enter_state():
	target.get_node("Timers/DifferenceRecalculationTimer").start()
	target.EngineFiring = true
	target.SetSpriteAngry()
	target.set_sleeping(false)
	target.DamageAllTouching()

# State machine callback called during transition when leaving this state
func _on_leave_state():
	target.get_node("Timers/DifferenceRecalculationTimer").stop()
	target.EngineFiring = false
