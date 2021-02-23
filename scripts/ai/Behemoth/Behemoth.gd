extends RigidBody2D
class_name Behemoth

signal exploded(position, size, rotation)
signal health_changed(oladHealth, newHealth)

const off = preload("res://scripts/ai/Behemoth/off.gd")
const pursue = preload("res://scripts/ai/Behemoth/pursue.gd")
const agitated = preload("res://scripts/ai/Behemoth/agitated.gd")
const stop = preload("res://scripts/ai/Behemoth/stop.gd")
const dead = preload("res://scripts/ai/Behemoth/dead.gd")
const StateMachineFactory = preload("res://scripts/systems/state-machine/state_machine_factory.gd")

export var MaxSpeed: float = 790
export var EngineStrength: float = 94000
export var TorqueImpulse: float = 1000000
export var MaxAngleDrift: float = 0.04
export var BehaviourChangeThreshold: float = 0.4

export var LinearDamp = 220
export var AngularDamp = 5

var Navigator
var Target: WeakRef
var aiState = null
var startState = "off"

#var TargetPath = null
var CursorThrust = null

# Elements health
var TopWireHealth = 0
var BottomWireHealth = 0 
var WireMaxHealth = 0

var ExplosionPoints: Array

func Save() -> Dictionary:
	var turretData: Dictionary = Dictionary()
	var powerNodes: Dictionary = Dictionary()
	
	for turret in $Turrets.get_children():
		if(turret is Turret):
			var turretName = turret.get_name()
			turretData[turretName] = turret.Save()
	
	for node in $Power.get_children():
		if(node is PowerNode):
			var nodeName = node.get_name()
			powerNodes[nodeName] = node.Save()
	
	return {
		"state": aiState.get_current_state(), #
		"cursor_thrust": String(CursorThrust) if CursorThrust != null else "", #
		"turrets": turretData, #
		"nodes": powerNodes, #
		"key_taken": true if get_node_or_null("KeyChamber/KeyPickup") == null else false, #
		"wire_max_health": WireMaxHealth, #
		"position": position, #
		"rotation": rotation, #
		"linear_velocity": linear_velocity, #
		"angular_velocity": angular_velocity #
	}

func Load(data: Dictionary):
	startState = data.state
	
	var pos = data.position.trim_prefix('(').trim_suffix(')').split(',')
	position = Vector2(pos[0], pos[1])
	var vel = data.linear_velocity.trim_prefix('(').trim_suffix(')').split(',')
	linear_velocity = Vector2(vel[0], vel[1])
	angular_velocity = data.angular_velocity
	rotation = data.rotation
	
	if(data.key_taken):
		$KeyChamber/KeyPickup.queue_free()
	
	if(data.cursor_thrust != ""):
		var thrust = data.cursor_thrust.trim_prefix('(').trim_suffix(')').split(',')
		CursorThrust = Vector2(thrust[0], thrust[1])
	
	WireMaxHealth = data.wire_max_health
	
	for turretName in data.turrets.keys():
		var turret = $Turrets.get_node_or_null(turretName)
		if(turret == null):
			continue
		
		turret.Load(data.turrets[turretName])
		
	for nodeName in data.nodes.keys():
		var node = $Power.get_node_or_null(nodeName)
		if(node == null):
			continue
		
		node.Load(data.nodes[nodeName])


func SetNavigator(navigator):
	Navigator = navigator


func GetNavigator():
	return Navigator


func SetTarget(target: Ship):
	Target = weakref(target)


func GetTarget() -> Ship:
	var tg = Target.get_ref()
	if(tg):
		return tg
	return null


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


func FarFromDist(distance: float):
	var collision: CircleShape2D = ($FarView/CollisionShape2D as CollisionShape2D).shape 
	return distance >= collision.radius


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
	SetNavigator(get_node_or_null("/root/Level/TriggerContainer/BehemothNavigator"))
	
	aiState = StateMachineFactory.create({
		'target': self,
		'current_state': startState,
		'states': [
			{'id': 'off', 'state': off},
			{'id': 'pursue', 'state': pursue},
			{'id': 'agitated', 'state': agitated},
			{'id': 'stop', 'state': stop},
			{'id': 'dead', 'state': dead}
		],
		'transitions': [
			{'state_id': 'off', 'to_states': ['agitated']},
			{'state_id': 'agitated', 'to_states': ['pursue', 'off', 'dead']},
			{'state_id': 'pursue', 'to_states': ['agitated', 'stop', 'dead']},
			{'state_id': 'stop', 'to_states': ['agitated', 'dead']}
		]
	})
	
	for turret in $Turrets.get_children():
		var _r = turret.connect("health_changed", self, "_on_turretHealthChange")
	
	TopWireHealth = _getTopWireHealth()
	BottomWireHealth = _getBottomWireHealth()
	if(WireMaxHealth == 0):
		WireMaxHealth = TopWireHealth + BottomWireHealth
	
	var level = get_node_or_null("/root/Level")
	if(level != null):
		var _r = connect("exploded", level, "_on_Something_explode")
		var camera = level.find_node("PlayerCamera")
		if(camera != null):
			var healthProgress = camera.find_node("BossHpProgressbar")
			if(healthProgress != null):
				_r = connect("health_changed", healthProgress, "_on_boss_hp_change")
				healthProgress.SetBossHealth(WireMaxHealth, TopWireHealth + BottomWireHealth)
				
	if(WireMaxHealth != TopWireHealth + BottomWireHealth):
		emit_signal("health_changed", WireMaxHealth, TopWireHealth + BottomWireHealth)



func _getTopWireHealth():
	return ($Power/PowerNode as PowerNode).GetHealth() \
			+ ($Power/PowerNode2 as PowerNode).GetHealth() \
			+ ($Power/PowerNode3 as PowerNode).GetHealth() \


func _getBottomWireHealth():
	return ($Power/PowerNode4 as PowerNode).GetHealth() \
			+ ($Power/PowerNode5 as PowerNode).GetHealth()


func _on_Topnode_health_changed(oldHealth, newHealth):
	var healthDiff = oldHealth - newHealth
	emit_signal("health_changed", TopWireHealth + BottomWireHealth, TopWireHealth + BottomWireHealth - healthDiff)
	TopWireHealth -= healthDiff
	if(TopWireHealth == 0):
		($Wires/WireTop_top as AnimatedSprite).frame = 1
		($Wires/WireTop_bottom as AnimatedSprite).frame = 1
	
	
	if(TopWireHealth == 0 && BottomWireHealth == 0):
		RemoveChamber()


func _on_Bottomnode_health_changed(oldHealth, newHealth):
	var healthDiff = oldHealth - newHealth
	emit_signal("health_changed", TopWireHealth + BottomWireHealth, TopWireHealth + BottomWireHealth - healthDiff)
	BottomWireHealth -= healthDiff
	if(BottomWireHealth == 0):
		($Wires/WireBottom_top as AnimatedSprite).frame = 1
		($Wires/WireBottom_bottom as AnimatedSprite).frame = 1
		
	if(TopWireHealth == 0 && BottomWireHealth == 0):
		aiState.transition("dead")


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
	_applyThrust()


func _integrate_forces(state):
	if(state.linear_velocity.length() > MaxSpeed):
		state.linear_velocity = state.linear_velocity.clamped(MaxSpeed)
	_applyRotation(state)


func _applyRotation(state: Physics2DDirectBodyState):
	if(CursorThrust == null):
		applied_torque = 0.0
		return
		
	var angleToCursor = (CursorThrust - position).angle() - rotation
	var absAngle = abs(angleToCursor)
	var component = angleToCursor / absAngle if angleToCursor != 0 else 0.0
	component *= -1
	
	LeftJets(component > 0)
	RightJets(component < 0)
	
	state.apply_torque_impulse(TorqueImpulse * component)


func _applyThrust():
	if(CursorThrust == null):
		applied_force = Vector2.ZERO
		return
	
	var impulseTo = (CursorThrust - position).normalized()
	applied_force = impulseTo * EngineStrength


func _onDeath():
	var explostionPoints = $ExplosionMarkers.get_children()
	explostionPoints.shuffle()
	ExplosionPoints = explostionPoints
	for turret in $Turrets.get_children():
		if(turret is Turret):
			turret.Damage(999)
			
	($ExplosionTimer as Timer).start()


func _on_ExplosionTimer_timeout():
	var point = ExplosionPoints.pop_front()
	if(point == null):
		($ExplosionTimer as Timer).stop()
		return
	var size = randf() * 3.2
	emit_signal("exploded", point.get_global_position(), size, 0.0)
	
func _on_turretHealthChange(_oldHealth, _newHealth):
	for turret in $Turrets.get_children():
		disconnect("health_changed", self, "_on_turretHealthChange")
	emit_signal("health_changed", WireMaxHealth, TopWireHealth + BottomWireHealth)

