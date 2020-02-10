tool
extends Node2D
class_name Wirerer

var PIECE = preload("res://scenes/entities/ConcreteEntities/Dynamic/WirePiece.tscn")
export (Array) var chainAmount = chainArray setget _setChainFunc,_getChainFunc
var chainArray: Array
var enterEditMode: bool = false
var pieces: int = 0


func _ready():
	var parent = $Anchor
	if(!Engine.is_editor_hint()):
		for angle in chainArray:
			parent = _addPiece(parent, angle)


func _setChainFunc(val):
	var temp: Array
	for item in val:
		if(!item is float && !item is int):
			temp.push_back(0.0)
		else:
			temp.push_back(item)

	chainArray = temp
	
	if(Engine.is_editor_hint()):
		_removePieces($Anchor)
		var parent = $Anchor
		for angle in chainArray:
			parent = _addPiece(parent, angle)


func _getChainFunc():
	return chainArray
	

func _removePieces(start):
	if(start == null):
		return
		
	var item = start
	print(item.get_children())
	print(item.get_node("CollisionShape2D/Joint").get_children())
	var children = item.get_node("CollisionShape2D/Joint").get_children()
	for child in children:
		child.queue_free()
		


func _addPiece(parent, rotation = 0):
	if(parent == null):
		return
	
	var joint = parent.get_node("CollisionShape2D/Joint")
	var piece = PIECE.instance()
	piece.set_name("WirePiece")
	piece.set_rotation(deg2rad(rotation))
	joint.add_child(piece)
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	return piece


func _on_Anchor_input_event(viewport, event, shape_idx):
	if(event is InputEventMouseButton):
		if(event.button_index == BUTTON_LEFT && event.doubleclick):
			enterEditMode = true
			update()

