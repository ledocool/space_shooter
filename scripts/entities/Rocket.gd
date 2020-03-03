extends Bullet
class_name Rocket

var LockedTarget = null
export var MaxTurnSpeed: float = 40
export var MaxSpeed: float = 200
export var EngineSpeed: float = 40

func Save():
	var prevSave = .Save()
	return prevSave


func Load(data: Dictionary):
	.Load(data)


func SpawnAt(pos: Vector2, angle: float, _add_velocity: Vector2):
	var anchor = GetSpawnAnchorPosition().rotated(angle)
	rotation = angle
	linear_velocity = linear_velocity.rotated(angle)
	self.position = pos - anchor
	self.apply_impulse(
		Vector2(0, 0), 
		Vector2(EngineSpeed, 0).rotated(rotation)
	)


func _init():
	Damage = 10


func _physics_process(delta):
	_ceilSpeed()


func _on_LockOnArea_body_exited(body):
	if(body == LockedTarget):
		LockedTarget = null


func _on_LockOnArea_body_entered(body):
	if(LockedTarget == null && body is Ship && !body is PlayerShip):
		LockedTarget = body


func _realign(delta):
	if(LockedTarget != null):
		var cursor = AiAPathHelper.Track(
			LockedTarget.get_global_position(), 
			LockedTarget.GetVelocity(), 
			self.get_global_position(), 
			self.GetVelocity()
		)
		look_at(cursor)
	applied_force = Vector2(EngineSpeed, 0).rotated(rotation)


func _ceilSpeed():
	linear_velocity = linear_velocity.clamped(MaxSpeed)

func _on_RealignTimer_timeout():
	_realign(($Timers/RealignTimer as Timer).wait_time)
