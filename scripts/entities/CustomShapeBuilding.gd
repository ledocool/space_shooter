tool
extends Node2D
class_name CustomShapeBilding

var dot = preload("res://resources/Effects/outline.png")
var dotImage = dot.get_data()
var img = Image.new()


func _ready():
	var polygon = $Walls/Walls.polygon
	$ColliderBody/CollisionPolygon2D.polygon = polygon
	_createOutline(polygon)
	$Walls/Walls.texture_scale = scale


func _createOutline(shape: PoolVector2Array):
	var margin = dotImage.get_size()
	var rect = _findTextureDimensions(shape, dotImage.get_size())
	img.create(rect.size.x, rect.size.y, false, dotImage.get_format())

	var first = true
	var lastNode = null
	var firstNode = null

	var dotSize = margin / 2;

	for node in shape:
		_addDot(rect.end - node)
		if (lastNode == null):
			firstNode = node
		else:
			_addDots(rect.end - lastNode, rect.end - node, dotSize)
		lastNode = node

	if(firstNode != null):
		_addDots(rect.end - firstNode, rect.end - lastNode, dotSize)

	var texture = ImageTexture.new()
	texture.create_from_image(img)
	var result = $Sprite.set_texture(texture)
	$Sprite.position = rect.end + (margin / 2)


func _findTextureDimensions(shape: PoolVector2Array, margin: Vector2) -> Rect2:
	var xSt = 0 
	var ySt = 0
	var xEd = 0
	var yEd = 0
	var first = true
	
	for node in shape:
		if(node.x > xEd || first): xEd = node.x
		if(node.x < xSt || first): xSt = node.x
		if(node.y > yEd || first): yEd = node.y
		if(node.y < ySt || first): ySt = node.y
		first = false
	
	return Rect2(floor(xSt - margin.x), floor(ySt - margin.y), ceil(xEd - xSt + margin.x), ceil(yEd - ySt + margin.y))


func _addDot(to: Vector2):
	img.blend_rect(dotImage, Rect2(Vector2.ZERO, dotImage.get_size()), to)


func _addDots(from: Vector2, to: Vector2, dotSize: Vector2):
	var movement = to - from
	var dotAmount = ceil(movement.length() / dotSize.x) #20 is dotsize
	for i in range(1, dotAmount):
		var offset = from + i * movement / dotAmount
		_addDot(offset)

