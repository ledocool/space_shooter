extends Node2D

var wirePiece = preload("res://scenes/entities/ConcreteEntities/Dynamic/Wire/WirePiece.tscn");

var pieces = 3 
var held_object = null


func _ready():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.connect("clicked", self, "_on_pickable_clicked")
	
	var lastAnchor = find_node("Anchor")
	var lastBody = find_node("Body")
	var lastPosition = Vector2(0, 0)
	
	for i in range(pieces):
		var piece = _addPiece()
		piece.set_position(lastAnchor.position + lastBody.position - piece.GetLeftAnchor().position)
		piece.add_to_group("pieces")
		lastAnchor = piece.GetRightAnchor()
		lastBody = piece.GetBody()

	lastBody = find_node("Body")
	for piece in get_tree().get_nodes_in_group("pieces"):
		if(lastBody != null):
			_joinAnchors(lastBody, piece)
		lastBody = piece
		print_debug(piece.position)
		
	var i = 1;
	for piece in get_tree().get_nodes_in_group("pieces"):
		if(i == 1):
			piece.free()
		else:
			piece.GetLeftAnchor().node_a = ""
		i += 1
		

func _on_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()

func _addPiece():
	var segment = wirePiece.instance()
	add_child(segment)
	return segment

func _joinAnchors(lastBody, newBody):
	var joint = newBody.GetLeftAnchor()
	joint.z_index = 1000
	print_debug(joint.position)
	joint.node_a = lastBody.get_path()
	joint.node_b = newBody.get_path()
	newBody.position = joint.position + Vector2(500, 0)
