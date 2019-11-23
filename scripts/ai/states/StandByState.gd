extends "res://scripts/addon/state-machine/state.gd"

const EnemyCheckTimeout = 2
var EnemyCheckCooldown = 0

func _on_enter_state():
	EnemyCheckCooldown = EnemyCheckTimeout
	
# State machine callback called during transition when leaving this state
func _on_leave_state(): pass

func _physics_process(delta):
	if(EnemyCheckCooldown <= 0):
		EnemyCheckCooldown = EnemyCheckTimeout
		if(target.SeesEnemy()):
			state_machine.transition("agitated")
		else:
			print("No enemy reported")
	else:
		EnemyCheckCooldown -= delta
	