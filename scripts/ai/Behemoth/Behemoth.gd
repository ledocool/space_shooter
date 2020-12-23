extends RigidBody2D
class_name Behemoth

const off = preload("res://scripts/ai/Behemoth/off.gd")
const pursue = preload("res://scripts/ai/Behemoth/pursue.gd")
const evade = preload("res://scripts/ai/Behemoth/evade.gd")
const agitated = preload("res://scripts/ai/Behemoth/agitated.gd")
const move_to = preload("res://scripts/ai/Behemoth/move_to.gd")
const StateMachineFactory = preload("res://scripts/systems/state-machine/state_machine_factory.gd")

var Navigator: Navigation2D
var Target: Ship
var aiState
var startState = "off"

func SetNavigator(navigator: Navigation2D):
	Navigator = navigator

func GetNavigator() -> Navigation2D:
	return Navigator
	
func SetTarget(target: Ship):
	Target = target

func GetTarget() -> Ship:
	return Target

func _ready():
	aiState = StateMachineFactory.create({
		'target': self,
		'current_state': startState,
		'states': [
			{'id': 'off', 'state': off},
			{'id': 'pursue', 'state': pursue},
			{'id': 'evade', 'state': evade},
			{'id': 'agitated', 'state': agitated},
			{'id': 'move_to', 'state': move_to}
		],
		'transitions': [
			{'state_id': 'off', 'to_states': ['agitated']},
			{'state_id': 'agitated', 'to_states': ['pursue', 'evade']},
			{'state_id': 'pursue', 'to_states': ['move_to']},
			{'state_id': 'evade', 'to_states': ['move_to']},
			{'state_id': 'move_to', 'to_states': ['agitated']},
		]
	})
