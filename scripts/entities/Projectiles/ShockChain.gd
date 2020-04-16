extends Node2D

var shockPlate = preload("res://scenes/entities/ConcreteEntities/Bullets/ShockPlate.tscn")
var enitityCounter = 0

export var entityOffset = 95
export var entityMax = 15


func SpawnAt(pos: Vector2, angle: float, _add_velocity: Vector2):
	rotation = angle
	self.position = pos


func spawnChild(position: Vector2):
	var instance = shockPlate.instance()
	instance.connect("tree_exited", self, "_onTreeExiting")
	instance.position = position
	add_child(instance)


func _ready():
	var currentPos = 0
	for i in range(0, entityMax):
		currentPos = (i + 1)*entityOffset
		var plate = Position2D.new()
		plate.name = "Position2D" + String(i)
		plate.position = Vector2(currentPos, 0)
		add_child(plate)


func _onTreeExiting():
	enitityCounter -= 1
	if(enitityCounter < 1):
		self.queue_free()


func _on_Timer1_timeout():
	if(enitityCounter >= entityMax):
		($Timers/Timer1 as Timer).stop()
		return
	
	var posName = "Position2D" + String(enitityCounter)
	var pos = get_node(posName)
	spawnChild(pos.position)
	enitityCounter += 1
