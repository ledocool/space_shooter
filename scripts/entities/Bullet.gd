extends RigidBody2D
class_name Bullet

signal exploded(position, size, rotation)

export var OutOfBoundsLifetime = 0.7
var LivedOutOfBounds = 0
var Collided = false

func _physics_process(delta):
	LivedOutOfBounds += delta
	if(LivedOutOfBounds >= OutOfBoundsLifetime || Collided):
		emit_signal("exploded", self.position, 0.06, rotation)
		free()
	
func GetSpawnAnchorPosition():
	return ($SpawnAnchor as Node2D).position

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
			
	Collided = true
	pass # Replace with function body.

func GetCoordinates():
	return position
	
func GetVelocity():
	return linear_velocity