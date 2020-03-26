extends Ship
class_name Miner

const IdleState = preload("res://scripts/ai/Miner/idle.gd")
const AgitatedState = preload("res://scripts/ai/Miner/agitated.gd")
const OffState = preload("res://scripts/ai/Miner/off.gd")
const Angryfying = preload("res://scripts/ai/Miner/angryfying.gd")
const StateMachineFactory = preload("res://scripts/systems/state-machine/state_machine_factory.gd")

export var ExplosionDamage = 3
export var TurnedOn = true

var aiState

var Player
var NearPlayer = false
var SeesPlayer = false
export var StartState = 'idle'


func Save():
	var data = .Save()
	data.state = aiState.get_current_state()
	var p = GetPlayer()
	if(p):
		data.target = get_path_to(p)
	return data


func Load(data: Dictionary):
	if(data.has("target")):
		Player = data.target
		if(data.has("state") && data.state != ""):
			StartState = data.state
			set_sleeping(false)
	return .Load(data)


func Damage(_dmg):
	return false


func TurnOn(isOn = true):
	TurnedOn = isOn
	if(TurnedOn):
		aiState.transition('idle')
	else:
		aiState.transition('off')


func IsOn():
	return TurnedOn


func IsNearPlayer():
	return NearPlayer


func IsSeesPlayer():
	return SeesPlayer


func TrackPlayer(player):	
	Cursor = AiAPathHelper.Track(player.get_global_position(), player.GetVelocity(), self.get_global_position(), self.GetVelocity())


func SetSpriteChill():
	($Sprite as AnimatedSprite).set_frame(1)


func SetSpriteAngry():
	($Sprite as AnimatedSprite).set_frame(0)


func UntrackPlayer():
	Cursor = null


func GetPlayer():
	if(Player == null): 
		return null 
	else: 
		return Player.get_ref()


func SetAiTimersTicking(isTicking):
	($Timers/DifferenceRecalculationTimer as Timer).set_paused(!isTicking)
	($Timers/SeesPlayerTimer as Timer).set_paused(!isTicking)


func _onDestruction():
	emit_signal("exploded", position, 0.25, rotation)


func _physics_process(delta):
	aiState._physics_process(delta);
	._physics_process(delta)


func _ready():
	if(Player is String):
		Player = weakref(get_node(Player))
	else:
		Player = null
	
	aiState = StateMachineFactory.create({
		'target': self,
		'current_state': StartState,
		'states': [
			{'id': 'idle', 'state': IdleState},
			{'id': 'agitated', 'state': AgitatedState},
			{'id': 'off', 'state': OffState},
			{'id': 'angryfying', 'state' : Angryfying}
		],
		'transitions': [
			{'state_id': 'idle', 'to_states': ['angryfying', 'off']},
			{'state_id': 'agitated', 'to_states': ['idle', 'off']},
			{'state_id': 'angryfying', 'to_states': ['agitated', 'off']},
			{'state_id': 'off', 'to_states': ['idle']},
		]
	})


func _on_AreaEnter_body_entered(body):
	if body is PlayerShip:
		NearPlayer = true
		Player = weakref(body)


func _on_AreaExit_body_exited(body):
	if body == GetPlayer():
		Player = null
		NearPlayer = false
		if(aiState.get_current_state() == "agitated"):
			aiState.transition('idle')


func _isSeesPlayer():
	var player = GetPlayer()
	if(player == null):
		return false;
	
	var pp = player.get_global_position()
	var selfPos = self.get_global_position()
	return AiAPathHelper.TargetVisible(selfPos, pp, get_world_2d())


func _on_ExplodeArea_body_entered(body):
	if(aiState.get_current_state() == "agitated" && body.has_method("Damage") && body != self):
		if(body.Damage(ExplosionDamage)):
			self.Damage(self.GetHealth())


func _on_SeesPlayerTimer_timeout():
	SeesPlayer = _isSeesPlayer()


func _on_DifferenceRecalculationTimer_timeout():
	var player = GetPlayer()
	if(player):
		TrackPlayer(player)


func _on_AngryfyingBlinkTimer_timeout():
	if(($Sprite as AnimatedSprite).frame == 0):
		SetSpriteChill()
	else:
		SetSpriteAngry()
