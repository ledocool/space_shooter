extends Node2D
class_name Turret

signal health_changed(oldHealth, newHealth)
signal exploded(position, size, rotation)
signal shoot_bullet(bullet_type, direction, location, velocity, damage_multiplier)

const idle = preload("res://scripts/ai/Turret/idle.gd")
const track = preload("res://scripts/ai/Turret/track.gd")
const shoot = preload("res://scripts/ai/Turret/shoot.gd")
const dead = preload("res://scripts/ai/Turret/dead.gd")
const StateMachineFactory = preload("res://scripts/systems/state-machine/state_machine_factory.gd")

const bullet = preload("res://scenes/entities/ConcreteEntities/Bullets/ShockChain.tscn")

export var Health = 7

var shotTimeout = 3
var LockedTarget = null
var aiState
var startState = "idle"


func Damage(dmg):
	var oldHealth = Health
	if(aiState.get_current_state() == 'dead'):
		return
	
	var OldHealth = Health
	Health -= dmg
	
	if(Health <= 0):
		Health = 0
		aiState.transition("dead")
		for pos in $Top/Explosions.get_children():
			emit_signal("exploded", pos.get_global_position(), 0.05, 0)
	
# warning-ignore:unsafe_property_access
	$Top/Sprite.frame += (OldHealth - Health)	
	emit_signal("health_changed", oldHealth, Health)


func Save():
	return {
		"position": position,
		"rotation": rotation,
		"top_rotation": ($Top as Node2D).rotation,
		"state": aiState.get_current_state(),
	}


func Load(data: Dictionary):
	var pos = data.position.trim_prefix('(').trim_suffix(')').split(',')
	position = Vector2(pos[0], pos[1])
	rotation = data.rotation
	($Top as Node2D).rotation = data.top_rotation
	startState = data.state


func GetCoordinates():
	return position

func GetRotation():
	return rotation


func GetVelocity(): 
	return Vector2.ZERO

func IsPlayerVisible():
	var target = GetTarget()
	if(!target):
		return false
	
	return AiAPathHelper.TargetVisible(position, target.position, get_world_2d())

func GetTarget():
	if(LockedTarget == null):
		return null
	
	var tg = LockedTarget.get_ref()
	if(tg):
		return tg
	else:
		LockedTarget = null
		return null


func StopCooldowns():
	($Timers/ShootBlowupCooldown as Timer).stop()
	($Timers/ShootCooldown as Timer).stop()


func Shoot():
	($Timers/ShootBlowupCooldown as Timer).start()
# warning-ignore:unsafe_property_access
	var rot = $Top.global_rotation
# warning-ignore:unsafe_property_access
	var pos = $Top/BulletAnchor.global_position
	emit_signal("shoot_bullet", bullet.instance(), rot, pos, Vector2(0,0), 1.0)

func SkipShoot():
	if(aiState.get_current_state() == "shoot"):
		aiState.transition("track")


func Track():
	var target = GetTarget()
	if(!target):
		return false
	
	var targetPosition = target.get_global_position()
	if(!AiAPathHelper.TargetVisible(position, target.position, get_world_2d())):
		return false

	($Top as Node2D).look_at(targetPosition)
	return true


func StartAftershootCooldown():
	var cooldown = ($Timers/ShootBlowupCooldown as Timer)
	cooldown.start()


func StartShootCooldown():
	var cooldown = ($Timers/ShootCooldown as Timer)
	cooldown.start()


func _ready():
	aiState = StateMachineFactory.create({
		'target': self,
		'current_state': startState,
		'states': [
			{'id': 'idle', 'state': idle},
			{'id': 'shoot', 'state': shoot},
			{'id': 'track', 'state': track},
			{'id': 'dead', 'state': dead}
		],
		'transitions': [
			{'state_id': 'idle', 'to_states': ['track','dead']},
			{'state_id': 'track', 'to_states': ['idle', 'shoot', 'dead']},
			{'state_id': 'shoot', 'to_states': ['track', 'idle', 'dead']}
		]
	})
	
	var level = $"/root/Level"
	if(level != null):
		var _res
		_res = connect("shoot_bullet", level, "_on_Ship_shoot")
		_res = connect("exploded", level, "_on_Something_explode")


func _physics_process(delta):
	aiState._physics_process(delta)


func _on_dead():
	($Base as StaticBody2D).set_collision_layer(1)
	($Top as KinematicBody2D).set_collision_layer(1)


func _on_Area2D_body_entered(body):
	if(body is PlayerShip):
		LockedTarget = weakref(body)
		if(aiState.get_current_state() == "idle"):
			aiState.transition("track")


func _on_Area2D_body_exited(body):
	if GetTarget() && body == GetTarget():
		if(aiState.get_current_state()):
			aiState.transition("idle")
		LockedTarget = null


func _on_ShootCooldown_timeout():
	if(aiState.get_current_state() == "track"):
		aiState.transition("shoot")


func _on_ShootBlowupCooldown_timeout():
	if(aiState.get_current_state() == "shoot"):
		aiState.transition("track")


func _on_Base_damaged(damage):
	Damage(damage)


func _on_Top_damaged(damage):
	Damage(damage)
