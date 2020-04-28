tool
extends Node2D
class_name CustomShapeBilding


# Called when the node enters the scene tree for the first time.
func _ready():
	var polygon = $ColliderBody/CollisionPolygon2D.polygon
	$Walls.polygon = polygon

