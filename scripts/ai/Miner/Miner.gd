extends Ship
class_name Miner

const IdleState = preload("res://scripts/ai/Miner/idle.gd")
const AgitatedState = preload("res://scripts/ai/Miner/agitated.gd")
const OffState = preload("res://scripts/ai/Miner/off.gd")
const StateMachineFactory = preload("res://scripts/systems/state-machine/state_machine_factory.gd")

export var ExplosionDamage = 3
export var TurnedOn = true

onready var smf = StateMachineFactory.new()
var aiState

var Player
var NearPlayer = false
var SeesPlayer = false

#func Save():
#	pass
#
#func Load(data: Dictionary):
#	pass

func TurnOn(isOn = true):
	TurnedOn = isOn

func IsOn():
	return TurnedOn

func IsNearPlayer():
	return NearPlayer

func IsSeesPlayer():
	return SeesPlayer

func UnproductiveFlight():
	var Player = GetPlayer()
	if(!Player):
		return false
	var vec1 = Player.GetCoordinates() - self.GetCoordinates()
	var vec2 = self. GetVelocity()
	var vecCos = vec1.x*vec2.x + vec1.y*vec2.y
	return vecCos <= 0

func TrackPlayer(Player):	
	var pp = Player.get_global_position()
	var speed = Player.GetVelocity() + self.GetVelocity()
	var fromThisToplayer = pp - self.get_global_position()
	
	var Difference = fromThisToplayer - speed
	var angle = fromThisToplayer.angle_to(Difference)
	
	if(abs(angle) > 0.1745329 && abs(angle) < 1.396263): #0.1745329 = 10 degrees; 1.396263 = 80 degrees; 2.792527 = 160 deg
		Cursor = self.get_global_position() + Difference
	else:
		Cursor = pp;


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

func _ready():	
	aiState = smf.create({
		'target': self,
		'current_state': 'idle',
		'states': [
			{'id': 'idle', 'state': IdleState},
			{'id': 'agitated', 'state': AgitatedState},
			{'id': 'off', 'state': OffState}
		],
		'transitions': [
			{'state_id': 'idle', 'to_states': ['agitated', 'off']},
			{'state_id': 'agitated', 'to_states': ['idle', 'off']},
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


func _isSeesPlayer():
	var player = GetPlayer()
	if(player == null):
		return false;
	
	var pp = player.get_global_position()
	var selfPos = self.get_global_position()
	var space_rid = get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)
	var intersected = space_state.intersect_ray(pp, selfPos, [], 524288)
	return intersected.empty()


func _on_ExplodeArea_body_entered(body):
	if(aiState.get_current_state() == "agitated" && body.has_method("Damage") && body != self):
		body.Damage(ExplosionDamage);
		self.Damage(self.GetHealth())
		

func _on_SeesPlayerTimer_timeout():
	SeesPlayer = _isSeesPlayer()


func _on_DifferenceRecalculationTimer_timeout():
	var player = GetPlayer()
	if(player):
		TrackPlayer(player)
