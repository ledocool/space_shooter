extends RigidBody2D
class_name Bullet

signal exploded(position, size, rotation)

func GetSpawnAnchorPosition():
	return ($SpawnAnchor as Node2D).position

func Save():
	return {
		"position": GetCoordinates(),
		"rotation": self.rotation,
		"velocity": GetVelocity(),
		"lifetime": $Timers/Lifespan.get_time_left()
	}
	
func Load(data: Dictionary):
	self.position = data.position
	self.rotation = data.rotation
	self.linear_velocity = data.velocity
	$Timers/Lifespan.set_wait_time(data.lifetime)

func Destroy():
	emit_signal("exploded", self.position, 0.06, rotation)
	queue_free()


func SpawnAt(pos: Vector2, angle: float, add_velocity: Vector2):
	var anchor = GetSpawnAnchorPosition().rotated(angle)
	rotation = angle
	linear_velocity = linear_velocity.rotated(rotation) + add_velocity
	self.position = pos - anchor

	
func Rotate(angle):
	self.rotation = angle


func _on_Bullet_body_entered(body):
	if(body.has_method("Damage")):
		body.Damage(1)
	Destroy()


func GetCoordinates():
	return position

	
func GetVelocity():
	return linear_velocity


func _on_Lifespan_timeout():
	Destroy()
