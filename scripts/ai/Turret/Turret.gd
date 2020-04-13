extends Node2D
class_name Turret

signal health_changed(oldHealth, newHealth)
signal exploded(position, size, rotation)
signal shoot_bullet()

const idle = preload("res://scripts/ai/Turret/idle.gd")
const track = preload("res://scripts/ai/Turret/track.gd")
const shoot = preload("res://scripts/ai/Turret/shoot.gd")
const StateMachineFactory = preload("res://scripts/systems/state-machine/state_machine_factory.gd")

const bullet = preload("res://scenes/entities/ConcreteEntities/Bullets/ShockChain.tscn")

export var Health = 3
export var MaxHelath = 3

var shotTimeout = 3
var LockedTarget = null
var aiState


func Damage(dmg):
	var oldHealth = Health
	Health -= dmg
	if Health <= 0:
		Health = 0
		emit_signal("exploded", self.position, 0.15, 0)
	
	emit_signal("health_changed", oldHealth, Health)


func Save():
	pass


func Load(data: Dictionary):
	pass


func GetTarget():
	if(LockedTarget == null):
		return null
	
	var tg = LockedTarget.get_ref()
	if(tg):
		return tg
	else:
		LockedTarget = null
		return null


func Shoot():
	($Timers/ShootBlowupCooldown as Timer).start()
	var rot = $Top.global_rotation
	var pos = $Top/BulletAnchor.global_position
	emit_signal("shoot_bullet", bullet, rot, pos, Vector2(0,0))


func Track():
	var target = GetTarget()
	if(!target):
		return

	var targetPosition = target.get_global_position()
	($Top as Node2D).look_at(targetPosition)


func StartAftershootCooldown():
	var cooldown = ($Timers/ShootBlowupCooldown as Timer)
	cooldown.start()


func StartShootCooldown():
	var cooldown = ($Timers/ShootCooldown as Timer)
	cooldown.start()


func _ready():
	aiState = StateMachineFactory.create({
		'target': self,
		'current_state': "idle",
		'states': [
			{'id': 'idle', 'state': idle},
			{'id': 'shoot', 'state': shoot},
			{'id': 'track', 'state': track}
		],
		'transitions': [
			{'state_id': 'idle', 'to_states': ['track']},
			{'state_id': 'track', 'to_states': ['idle', 'shoot']},
			{'state_id': 'shoot', 'to_states': ['track', 'idle']}
		]
	})


func _physics_process(delta):
	aiState._physics_process(delta)


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
