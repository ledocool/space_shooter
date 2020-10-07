extends Bullet
class_name Rocket

#export var MaxTurnSpeed: float = 40
export var MaxSpeed: float = 1200
export var EngineSpeed: float = 10
export var StartImpulse: float = 1300

var LockedTarget = null
var OldForce = Vector2(0,0)
var LastRotation = 0


func Save():
	var prevSave = .Save()
	return prevSave


func Load(data: Dictionary):
	.Load(data)


func SpawnAt(pos: Vector2, angle: float, add_velocity: Vector2):
	var anchor = GetSpawnAnchorPosition().rotated(angle)
	LastRotation = angle
	linear_velocity = add_velocity
	self.position = pos - anchor
	_rotate(angle)
	apply_impulse(Vector2(), Vector2(StartImpulse, 0).rotated(angle))


func GetTarget():
	if(LockedTarget == null): 
		return null 
	else: 
		return LockedTarget.get_ref()


func _ready():
	._ready()
# warning-ignore:unsafe_method_access
	$EngineSound.play()


func _init(damage_multiplier = null):
	._init(damage_multiplier)
	Damage = 10


func _integrate_forces(state):
	var target = GetTarget()
	var rot = LastRotation
	
	if(target):
		var cursor = AiAPathHelper.Track(
				target.get_global_position(), 
				target.GetVelocity(), 
				self.get_global_position(), 
				self.GetVelocity()
		)
		rot = cursor.angle() 
		LastRotation = rot
		
	var force = Vector2(EngineSpeed, 0).rotated(rot)
	
	state.add_central_force(-OldForce)
	state.add_central_force(force)
	OldForce = force
	_ceilSpeed()


func _draw():
	var target = GetTarget()
	if(target):
		var targetPos = target.position
		draw_line(Vector2(0,0), targetPos - position, Color.red, 3)


func _process(_delta):
	if(linear_velocity.length_squared() > 1):
		var rot = linear_velocity.angle()
		_rotate(rot)


func _rotate(rot):
	($Sprite as Sprite).rotation = rot
# warning-ignore:unsafe_property_access
	$CollisionShape2D.rotation = rot - deg2rad(90)
# warning-ignore:unsafe_property_access
	$LockOnArea.rotation = rot
# warning-ignore:unsafe_property_access
	$ShootLockOnArea.rotation = rot


func _switchToRadial():
	($ShootLockOnArea/CollisionShape2D as CollisionShape2D).set_disabled(true)
	($LockOnArea/CollisionShape2D as CollisionShape2D).set_disabled(false)

func _on_LockOnArea_body_exited(body):
	var target = GetTarget()
	if(body == target):
		LockedTarget = null


func _on_LockOnArea_body_entered(body):
	if(GetTarget() == null && (body is Ship && !body is PlayerShip || body is TurretPart)):
		LockedTarget = weakref(body)
		call_deferred("_switchToRadial")


func _ceilSpeed():
	linear_velocity = linear_velocity.clamped(MaxSpeed)


func _on_ShootLockOnArea_body_entered(body):
	if(body is Ship && !body is PlayerShip || body is TurretPart):
		LockedTarget = weakref(body)
		call_deferred("_switchToRadial")


func _on_PriorityTargetDisableTimer_timeout():
	call_deferred("_switchToRadial")
