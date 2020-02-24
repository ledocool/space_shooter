extends Bullet
class_name Rocket

var LockedTarget = null
export var MaxTurnSpeed: float = 40

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


func _init():
	Damage = 10


func _physics_process(delta):
	_realign(delta)


func _on_LockOnArea_body_exited(body):
	if(body == LockedTarget):
		LockedTarget = null


func _on_LockOnArea_body_entered(body):
	if(LockedTarget == null && body is Ship && !body is PlayerShip):
		LockedTarget = body


func _realign(delta):
	if(LockedTarget != null):
		var vec = LockedTarget.position - position
		var angle = vec.angle_to(linear_velocity)
		var cap = deg2rad(MaxTurnSpeed) * delta
		if(abs(angle) > 1e-3):
			angle = clamp(angle, -cap, cap)
			linear_velocity = linear_velocity.rotated(-angle)
			rotation = linear_velocity.angle()


func _on_RealignTimer_timeout():
	_realign(($Timers/RealignTimer as Timer).wait_time)
