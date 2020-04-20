extends Node2D

# warning-ignore:unused_signal
signal exploded(position, size, rotation)

var shockPlate = preload("res://scenes/entities/ConcreteEntities/Bullets/ShockPlate.tscn")
var enitityCounter = 0

export var entityOffset = 95
export var entityMax = 15


func Save():
	var entities: Array = []
	for entity in get_children():
		if(entity is ShockPlate):
			var entityData = entity.Save()
			entities.append(entityData)
	
	return {
		"position": position,
		"rotation": rotation,
		"entities": entities
	}


func Load(data: Dictionary):
	var currentPos = 0
	var pos = data.position.trim_prefix('(').trim_suffix(')').split(',')
	position = Vector2(pos[0], pos[1])
	rotation = data.rotation
	for entityData in data.entities:
		var plate = shockPlate.instance()
		plate.Load(entityData)
		currentPos = (enitityCounter + 1)*entityOffset
		plate.position = Vector2(currentPos, 0)
		add_child(plate)
		enitityCounter += 1


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
	var oldEntityCounter = enitityCounter
	for i in range(oldEntityCounter, entityMax):
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
