#extends Node
#
#const StateMachineFactory = preload("res://scripts/systems/state-machine/state_machine_factory.gd")
#const StandByState = preload("res://scripts/ai/states/StandByState.gd")
#const AgitatedState = preload("res://scripts/ai/states/AgitatedState.gd")
#const ShootState = preload("res://scripts/ai/states/ShootState.gd")
#const WasteTimeState = preload("res://scripts/ai/states/WasteTimeState.gd")
#const AimState = preload("res://scripts/ai/states/AimState.gd")
#const MoveState = preload("res://scripts/ai/states/MoveState.gd")
#const MoveCloserState = preload("res://scripts/ai/states/MoveCloserState.gd")
#const MoveAwayState = preload("res://scripts/ai/states/MoveAwayState.gd")
#const EvasionState = preload("res://scripts/ai/states/EvasionState.gd")
#
#onready var Ship = get_parent()
#onready var Level = Ship.get_parent()
#onready var Player = weakref(Level.GetPlayer())
#var EvadedObject
#
#var ShipNearestDistance = 150
#var ShipEvadeDistance = 310
#var ShipFurthestDistance = 520
#var AIVisibilityRange = 900
#var ShipShootLongevity = 2
#
#var NeedEvade = false
#var TooClose = false
#var TooFar = false
#
#onready var smf = StateMachineFactory.new()
#
#var BurnCooldown = 0
#var ActionCooldown = 0
#var ShootCooldown = 0
#var ShipShootCooldown = 0 
#
#var aiState
#
#func _ready():
#	aiState = StateMachineFactory.create({
#		'target': self,
#		'current_state': 'stand_by',
#		'states': [
#			{'id': 'stand_by', 'state': StandByState},
#			{'id': 'agitated', 'state': AgitatedState},
#			{'id': 'move', 'state': MoveState},
#			{'id': 'move_closer', 'state': MoveCloserState},
#			{'id': 'move_away', 'state': MoveAwayState},
#			{'id': 'evasion', 'state': EvasionState},
#			{'id': 'waste_time', 'state': WasteTimeState},
##			{'id': 'pick_target', 'state': PickTarget},
#			{'id': 'shoot', 'state': ShootState},
#			{'id': 'aim', 'state': AimState}
#		],
#		'transitions': [
#			{'state_id': 'stand_by', 'to_states': ['agitated']},
#			{'state_id': 'agitated', 'to_states': ['stand_by', 'aim', 'waste_time', 'move']},
##			{'state_id': 'agitated', 'to_states': ['stand_by', 'pick_target', 'aim', 'move']},
##			{'state_id': 'pick_target', 'to_states': ['agitated']},
#			{'state_id': 'waste_time', 'to_states': ['agitated']},
#			{'state_id': 'move', 'to_states': ['agitated', 'move_closer', 'move_away', 'evasion']},
#			{'state_id': 'aim', 'to_states': ['shoot', 'agitated']},
#			{'state_id': 'shoot', 'to_states': ['agitated']},
#			{'state_id': 'move_closer', 'to_states': ['agitated']},
#			{'state_id': 'move_away', 'to_states': ['agitated']},
#			{'state_id': 'evasion', 'to_states': ['agitated']},
#		]
#	})
#
#	Ship.connect("shoot_bullet", self, '_on_bullet_shot')
#
#func _on_bullet_shot():
#	StopShooting()
#	pass
#
#func _physics_process(delta):
#	if(BurnCooldown > 0):
#		BurnCooldown -= delta
#	if(ShipShootCooldown > 0):
#		ShipShootCooldown -= delta
#
#	if(BurnCooldown <= 0):
#		Ship.EngineFiring = false
#
#	aiState._physics_process(delta)
#
#func CalculateDistance(Body):
#	if(!Body.has_method("GetCoordinates")):
#		return -1;
#
#	var myPosition = Ship.GetCoordinates()
#	var playerPosition = Body.GetCoordinates()
#
#	return myPosition.distance_to(playerPosition)
#
#func Aim():
#	if(!Player.get_ref()):
#		return false;
#	return AimAt(Player.get_ref())
#
#
#func AimAt(Body):
#	if(!Body.has_method("GetCoordinates")):
#		return false;	
##	var TargetSpeedSquared = Body.linear_velocity.length_squared()
##	var BulletSpeedSquared = Ship.CalculateBulletSpeed().length_squared()
##	var DistanceSquared = (Body.position - Ship.position).length_squared()
##	var proportion = sqrt(TargetSpeedSquared/BulletSpeedSquared)
##
##	var angleSin = sin(Body.rotation) * proportion
##	var angleCos = - (TargetSpeedSquared - DistanceSquared - BulletSpeedSquared)\
##		/ (2 * sqrt(DistanceSquared) * sqrt(BulletSpeedSquared))
##
##	var angle = asin(angleSin)
##	Ship.set_rotation( atan2(angleSin, angleCos) )
#
#	Ship.Cursor = Body.GetCoordinates()
#	return true
#
#func SeesEnemy():
#	if(!Player.get_ref()):
#		return false;
#	return AIVisibilityRange >= CalculateDistance(Player.get_ref())
#
#func CanShoot():
#	return ShootCooldown <= 0
#
#func NeedMove():
#	if(BurnCooldown > 0):
#		return false
#
#	var StrongPlayer = Player.get_ref()
#	if(!StrongPlayer):
#		return false
#
#	var distance = CalculateDistance(StrongPlayer)
#	self.TooClose = distance < ShipNearestDistance
#	self.TooFar = distance > ShipFurthestDistance
#	var bullets = Level.GetBulltets(Ship.position, AIVisibilityRange, 999)
#	self.NeedEvade = false
#	EvadedObject = null
#	for bullet in bullets:
#		var bulletDistance = CalculateDistance(bullet)
#		if(bulletDistance > AIVisibilityRange):
#			continue
#
#		if(bulletDistance <= ShipEvadeDistance
#			&& abs(bullet.GetVelocity().angle_to(Ship.position - bullet.position)) <= deg2rad(15)
#			&& bullet.GetVelocity().angle_to(Ship.position - bullet.position) <= deg2rad(90)):
#			print_debug(rad2deg(bullet.GetVelocity().angle_to(Ship.position - bullet.position)))
#			print_debug(bulletDistance <= ShipEvadeDistance)
#			print_debug(abs((Ship.position - bullet.position).angle_to(bullet.GetVelocity())) <= deg2rad(15))	
#
#			self.NeedEvade = true
#			print_debug("Evade! Evade!")
#			EvadedObject = weakref(bullet)
#			break
#
#	return NeedEvade || TooClose || TooFar
#
#func NeedEvade():
#	return NeedEvade
#
#func TooClose():
#	return TooClose
#
#func TooFar():
#	return TooFar
#
#func Shoot():
#	Ship.CannonFiring = true
#
#func StopShooting():
#	ShipShootCooldown = ShipShootLongevity
#	Ship.CannonFiring = false
#
#func MoveCloser():
#	if(!Player.get_ref()):
#		return
#
#	Ship.Cursor = Player.get_ref().position
#	Ship.EngineFiring = true
#	BurnCooldown = 0.1
#
#func MoveAway():
#	if(!Player.get_ref()):
#		return
#
#	var fromOneToAnother = Ship.position - Player.get_ref().position
#	Ship.Cursor = Ship.position + fromOneToAnother
#	Ship.EngineFiring = true
#	BurnCooldown = 0.1
#
#func Evade():
#	print_debug("evading")
#	var Evaded = EvadedObject.get_ref();
#	if(!Evaded):
#		return
# 	var ProjectilePosition = Evaded.position
#	var ProjectileVelocity = Evaded.linear_velocity
#	var velAngle = ProjectileVelocity.angle()
#	var addangle = 0
#	if((Evaded.linear_velocity).angle_to_point(Ship.position - Evaded.position) > 0):
#		addangle = deg2rad(90)
#	else:
#		addangle = -deg2rad(90)
#
##	var shipAngle = Vector2(0, 1).rotated(velAngle)
#	Ship.Cursor = velAngle+addangle
#	Ship.EngineFiring = true
#	BurnCooldown = 0.1
#
#func Burning():
#	return BurnCooldown > 0
