tool
extends Node2D
class_name Wirerer

signal wire_switch(isOn)

var PIECE = preload("res://scenes/entities/ConcreteEntities/Dynamic/WirePiece.tscn")
var GENERATOR = preload("res://scenes/entities/ConcreteEntities/Dynamic/Destructible/Generator.tscn")
var SOCKET = preload("res://scenes/entities/ConcreteEntities/Static/Socket.tscn")

export (Array) var chainAmount = chainArray setget _setChainFunc,_getChainFunc
enum NodeTypes {generator, socket}
export (NodeTypes) var StartNodeType = 0 setget _setStartType,_getStartType
export (float) var StartNodeRotation setget _setStartNodeRotation,_getStartNodeRotation
export (float) var EndNodeRotation setget _setEndNodeRotation,_getEndNodeRotation


var chainArray: Array
var startNode
var endNode
var startNodeRotation = 0
var endNodeRotation = 0
var created = false

func Enable():
	if(created):
		emit_signal("wire_switch", true)
	for child in $Anchor.get_children():
		if(child.has_method("Enable")):
			child.Enable()


func Disable():
	if(created):
		emit_signal("wire_switch", false)
	for child in $Anchor.get_children():
		if(child.has_method("Disable")):
			child.Disable()


func _ready():
	if(!Engine.is_editor_hint()):
		_buildChain()
	Enable()
	created = true;


func _setStartNodeRotation(val):
	startNodeRotation = val
	
	if(Engine.is_editor_hint()):
		_removePieces($Anchor)
		_buildChain()


func _getStartNodeRotation():
	return startNodeRotation


func _setStartType(val):
	startNode = val
	
	if(Engine.is_editor_hint()):
		_removePieces($Anchor)
		_buildChain()


func _getStartType():
	return startNode


func _setEndNodeRotation(val):
	endNodeRotation = val
	
	if(Engine.is_editor_hint()):
		_removePieces($Anchor)
		_buildChain()


func _getEndNodeRotation():
	return endNodeRotation


func _setChainFunc(val):
	var temp: Array = [];
	for item in val:
		if(!item is float && !item is int):
			temp.push_back(0.0)
		else:
			temp.push_back(item)
	chainArray = temp
	
	if(Engine.is_editor_hint()):
		_removePieces($Anchor)
		_buildChain()


func _buildChain():
	var parent = $Anchor
	var start
	var end = SOCKET.instance()
	
	match(startNode):
		0:	
			start = GENERATOR.instance()
			start.connect("wire_switch", self, "_on_Generator_switch")
		1:	start = SOCKET.instance()
		_: 	start = SOCKET.instance()
	
	parent.add_child(start)
	parent = start
	for angle in chainArray:
		parent = _addPiece(parent, PIECE.instance(), angle)
	
	parent = _addPiece(parent, end, endNodeRotation)


func _getChainFunc():
	return chainArray


func _removePieces(start):
	if(start == null):
		return
	
	var item = start
	var children = item.get_children()
	for child in children:
		child.queue_free()

#var piece = PIECE.instance()
func _addPiece(parent, piece, rotation = 0):
	if(parent == null):
		return
	
	var joint = parent.find_node("Joint")
	piece.set_name("WirePiece")
	piece.set_rotation(deg2rad(rotation))
	joint.add_child(piece)
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	return piece
	
	
func _on_Generator_switch(enabled):
	emit_signal("wire_switch", enabled)
