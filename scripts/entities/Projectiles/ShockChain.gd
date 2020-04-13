extends Node2D

var shockPlate = preload("res://scenes/entities/ConcreteEntities/Bullets/ShockPlate.tscn")
var enitityCounter = 0


func SpawnAt(pos: Vector2, angle: float, _add_velocity: Vector2):
	rotation = angle
	self.position = pos


func spawnChild(position: Vector2):
	var instance = shockPlate.instance()
	instance.connect("tree_exited", self, "_onTreeExiting")
	instance.position = position
	add_child(instance)
	enitityCounter += 1


func _onTreeExiting():
	enitityCounter -= 1
	if(enitityCounter < 1):
		self.queue_free()


func _on_Timer1_timeout():
	spawnChild($Position2D1.position)


func _on_Timer2_timeout():
	spawnChild($Position2D2.position)


func _on_Timer3_timeout():
	spawnChild($Position2D3.position)
