extends RigidBody2D
class_name Behemoth

const off = preload("res://scripts/ai/Behemoth/off.gd")
const pursue = preload("res://scripts/ai/Behemoth/pursue.gd")
const evade = preload("res://scripts/ai/Behemoth/evade.gd")
const agitated = preload("res://scripts/ai/Behemoth/agitated.gd")
const stop = preload("res://scripts/ai/Behemoth/stop.gd")
const StateMachineFactory = preload("res://scripts/systems/state-machine/state_machine_factory.gd")

export var MaxSpeed: float = 790
export var EngineStrength: float = 94000
export var TorqueImpulse: float = 1000000
export var MaxAngleDrift: float = 0.04
export var BehaviourChangeThreshold: float = 0.4

export var LinearDamp = 94000
export var AngularDamp = 400

var Navigator
var Target: Ship
var aiState = null
var startState = "off"

var TargetPath = null
var CursorThrust = null

var TopWireHealth = 0
var BottomWireHealth = 0
var WireMaxHealth = 0

var TurretsHealth = 0


func SetNavigator(navigator):
	Navigator = navigator

func GetNavigator():
	return Navigator


func SetTarget(target: Ship):
	Target = target


func GetTarget() -> Ship:
	return Target


func TurretsEnable(enable: bool = true):
	for turret in $Turrets.get_children():
		if(turret is Turret):
			turret.SetSuspended(!enable)


func CloseTo(ship: Ship):
	if(ship == null):
		return false
	return ($CloseView as Area2D).overlaps_body(ship)


func CloseToPos(pos: Area2D):
	if(pos == null):
		return false
	return ($CloseView as Area2D).overlaps_area(pos)


func FarFrom(ship):
	if(ship == null):
		return false
	return !($FarView as Area2D).overlaps_body(ship)


func FarFromPos(pos: Area2D):
	if(pos == null):
		return false
	return !($CloseView as Area2D).overlaps_area(pos)


func IsStationary():
	return linear_velocity.length() < 1e-1


func GetTurretsHealth():
	var health = 0
	for turret in $Turrets.get_children():
		health += turret.GetHealth()
		
	return health

func GetPowerNodeBottomHealth():
	return BottomWireHealth


func GetPowerNodeTopHealth():
	return TopWireHealth


func GetPowerNodeMaxHealth():
	return WireMaxHealth


func GetBehaviourChangeThreshold():
	return BehaviourChangeThreshold


func Thrust(to: Vector2):
	CursorThrust = to


func RemoveChamber():
	($KeyChamber as KeyChamber).Explodes()


func _ready():
	SetTarget(get_node_or_null("/root/Level/ShipContainer/Player"))
	
	aiState = StateMachineFactory.create({
		'target': self,
		'current_state': startState,
		'states': [
			{'id': 'off', 'state': off},
			{'id': 'pursue', 'state': pursue},
			{'id': 'evade', 'state': evade},
			{'id': 'agitated', 'state': agitated},
			{'id': 'stop', 'state': stop}
		],
		'transitions': [
			{'state_id': 'off', 'to_states': ['agitated']},
			{'state_id': 'agitated', 'to_states': ['pursue', 'evade', 'off']},
			{'state_id': 'pursue', 'to_states': ['agitated', 'stop']},
			{'state_id': 'evade', 'to_states': ['agitated', 'stop']},
			{'state_id': 'stop', 'to_states': ['agitated']}
		]
	})
	TurretsEnable(false)
	TopWireHealth = _getTopWireHealth()
	BottomWireHealth = _getBottomWireHealth()
	WireMaxHealth = TopWireHealth + BottomWireHealth


func _getTopWireHealth():
	return ($Power/PowerNode as PowerNode).GetHealth() \
			+ ($Power/PowerNode2 as PowerNode).GetHealth() \
			+ ($Power/PowerNode3 as PowerNode).GetHealth() \


func _getBottomWireHealth():
	return ($Power/PowerNode4 as PowerNode).GetHealth() \
			+ ($Power/PowerNode5 as PowerNode).GetHealth()


func _on_Topnode_health_changed(oldHealth, newHealth):
	var healthDiff = oldHealth - newHealth
	TopWireHealth -= healthDiff
	if(TopWireHealth == 0):
		($Wires/WireTop_top as AnimatedSprite).frame = 1
		($Wires/WireTop_bottom as AnimatedSprite).frame = 1
		
	if(TopWireHealth == 0 && BottomWireHealth == 0):
		RemoveChamber()


func _on_Bottomnode_health_changed(oldHealth, newHealth):
	var healthDiff = oldHealth - newHealth
	BottomWireHealth -= healthDiff
	if(BottomWireHealth == 0):
		($Wires/WireBottom_top as AnimatedSprite).frame = 1
		($Wires/WireBottom_bottom as AnimatedSprite).frame = 1
		
	if(TopWireHealth == 0 && BottomWireHealth == 0):
		RemoveChamber()


func LeftJets(enable: bool):
	($Jets/LowerLeft as Node2D).visible = enable
	($Jets/UpperLeft as Node2D).visible = enable


func RightJets(enable: bool):
	($Jets/Right as Node2D).visible = enable


func ForwardJets(enable: bool):
	($Jets/MainBack as Node2D).visible = enable
	($Jets/SecondaryBack as Node2D).visible = enable


func _physics_process(delta):
	aiState._physics_process(delta)
	_applyRotation()
	_applyThrust()


func _integrate_forces(state):
	if(state.linear_velocity.length() > MaxSpeed):
		state.linear_velocity = state.linear_velocity.clamped(MaxSpeed)


func _applyRotation():
	if(CursorThrust == null):
		applied_torque = 0.0
		LeftJets(false)
		RightJets(false)
		return
		
	var angleToCursor = (CursorThrust - position).angle() - rotation
	var absAngle = abs(angleToCursor)
	var component = angleToCursor / absAngle if angleToCursor != 0 else 0.0
	
	if(absAngle < MaxAngleDrift):
		LeftJets(false)
		RightJets(false)
	else:
		LeftJets(component > 0)
		RightJets(component < 0)
	
	applied_torque = TorqueImpulse * component


func _applyThrust():
	if(CursorThrust == null):
		ForwardJets(false)
		applied_force = Vector2.ZERO
		return
	
	var impulseTo = (CursorThrust - position).normalized()
	applied_force = impulseTo * EngineStrength
	ForwardJets(true)

