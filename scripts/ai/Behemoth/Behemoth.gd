extends RigidBody2D
class_name Behemoth

const off = preload("res://scripts/ai/Behemoth/off.gd")
const pursue = preload("res://scripts/ai/Behemoth/pursue.gd")
const evade = preload("res://scripts/ai/Behemoth/evade.gd")
const agitated = preload("res://scripts/ai/Behemoth/agitated.gd")
const StateMachineFactory = preload("res://scripts/systems/state-machine/state_machine_factory.gd")

var Navigator: Navigation2D
var Target: Ship
var TargetPath = null
var aiState = null
var startState = "off"

func SetNavigator(navigator: Navigation2D):
	Navigator = navigator

func GetNavigator() -> Navigation2D:
	return Navigator
	
func SetTarget(target: Ship):
	Target = target

func GetTarget() -> Ship:
	return Target

func TurretsEnable(enable: bool = true):
	pass
	
func CloseTo(position: Vector2):
	pass
	
func FarFrom(position: Vector2):
	pass

func _ready():
	SetTarget($"/root/Level/ShipContainer/Player")
	
	aiState = StateMachineFactory.create({
		'target': self,
		'current_state': startState,
		'states': [
			{'id': 'off', 'state': off},
			{'id': 'pursue', 'state': pursue},
			{'id': 'evade', 'state': evade},
			{'id': 'agitated', 'state': agitated}
		],
		'transitions': [
			{'state_id': 'off', 'to_states': ['agitated']},
			{'state_id': 'agitated', 'to_states': ['pursue', 'evade', 'off']},
			{'state_id': 'pursue', 'to_states': ['agitated']},
			{'state_id': 'evade', 'to_states': ['agitated']}
		]
	})

func _physics_process(delta):
	aiState._physics_process(delta)
