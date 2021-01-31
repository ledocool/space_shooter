extends Navigation2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func purge_areas():
	for child in $PathCheckpoints.get_children():
		child.queue_free()

func get_simple_path(from: Vector2, to: Vector2, optimize: bool = true):
	var path = .get_simple_path(from, to, optimize)
	var i = 0	
	for ck in path:
		var check = Area2D.new()
		var collision = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.radius = 1
		collision.shape = shape
		
		check.name = "Checkpoint" + String(i)
		check.set_collision_layer(128)
		check.position = ck
		check.add_child(collision)
		
		$PathCheckpoints.add_child(check)
		i += 1
		
	return path

func get_check_areas():
	return $PathCheckpoints.get_children()
