extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func Save():
	return {
		"position": position,
		"rotation": rotation,
		"velocity": linear_velocity
	}
	
func Load(data: Dictionary):
	var pos = data.position.trim_prefix('(').trim_suffix(')').split(',')
	position = Vector2(pos[0], pos[1])
	var vel = data.velocity.trim_prefix('(').trim_suffix(')').split(',')
	linear_velocity = Vector2(vel[0], vel[1])
	rotation = data.rotation