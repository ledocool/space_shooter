extends "res://scripts/addon/state-machine/state.gd"

const TimeWasteTimeout = 1
var TimeWasteCooldown = 0

func _on_enter_state():
	TimeWasteCooldown = TimeWasteTimeout

func _physics_process(delta):
	if(TimeWasteCooldown <= 0):
		print("Time wasted")
		state_machine.transition("agitated")
	else:
		TimeWasteCooldown -= delta