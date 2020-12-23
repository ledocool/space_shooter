tool
extends Node2D
class_name CustomShapeBilding

var dot = preload("res://resources/Effects/outline.png")
var dotImage = dot.get_data()
var img = Image.new()


func _ready():
# warning-ignore:unsafe_property_access
	var polygon = $Walls/Walls.polygon
	var linePolygon = polygon
	linePolygon.append(linePolygon[0])
	var lastVector: Vector2 = linePolygon[1] - linePolygon[0]
	var veryLastPoint = linePolygon[linePolygon.size() - 1 ] + \
		(lastVector.normalized() * 1.1)
		
	linePolygon.append(veryLastPoint)
# warning-ignore:unsafe_property_access
	$ColliderBody/CollisionPolygon2D.polygon = polygon
# warning-ignore:unsafe_property_access
	$Edge.points = linePolygon
	$Edge.position = $Walls/Walls.position
	$Walls/WallsOverlay.position = $Walls/Walls.position
# warning-ignore:unsafe_property_access
	$Walls/WallsOverlay.polygon = polygon
	#_createOutline(polygon)
# warning-ignore:unsafe_property_access
	$Walls/Walls.texture_scale = scale


func _createOutline(shape: PoolVector2Array):
	var margin = dotImage.get_size()
	var rect = _findTextureDimensions(shape, dotImage.get_size())
	img.create(rect.size.x, rect.size.y, false, dotImage.get_format())

# warning-ignore:unused_variable
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
# warning-ignore:unsafe_method_access
# warning-ignore:unused_variable
# warning-ignore:unsafe_method_access
	var result = $Sprite.set_texture(texture)
# warning-ignore:unsafe_property_access
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

