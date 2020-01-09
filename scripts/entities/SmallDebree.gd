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
	position = data.position
	rotation = data.rotation
	linear_velocity = data.velocity