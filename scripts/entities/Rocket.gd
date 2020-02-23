extends Bullet
class_name Rocket

var LockedTarget = null
export var MaxSpeed: float = 300

func _init():
	Damage = 10


func Save():
	var prevSave = .Save()
	return prevSave


func Load(data: Dictionary):
	.Load(data)


func SpawnAt(pos: Vector2, angle: float, add_velocity: Vector2):
	var anchor = GetSpawnAnchorPosition().rotated(angle)
	rotation = angle
	linear_velocity = add_velocity
	applied_force = applied_force.rotated(rotation)
	self.position = pos - anchor


func _on_LockOnArea_body_exited(body):
	if(body is Ship && !body is PlayerShip):
		LockedTarget = body


func _on_LockOnArea_body_entered(body):
	if(body == LockedTarget):
		LockedTarget = null


func _on_RealignTimer_timeout():
	if(LockedTarget != null):
		look_at(LockedTarget.position)
