extends Area2D
class_name Collectable

signal picked_up (data)

var data = Pickup.new()
var previouslyConnected: Array = []

func _ready():
	for connection in previouslyConnected:
		var target = get_node_or_null(connection.target)
		if(target):
# warning-ignore:return_value_discarded
			connect("picked_up", target, connection.method)
	
	previouslyConnected = []

func _on_Collectable_body_entered(body):
	if(body.has_method("PickUp")):
		if(body.PickUp(data, position)):
			visible = false
			emit_signal("picked_up", data)
			queue_free()

func Save():
	var signalConnections = get_signal_connection_list("picked_up")
	var refinedConnections: Array = []
	for connection in signalConnections:
		refinedConnections.append({
			"target": .get_path_to(connection.target),
			"method": connection.method
		})
	
	return {
		"position": position,
		"picked_up_connections": refinedConnections
	}


func Load(dt: Dictionary):
	var pos = dt.position.trim_prefix('(').trim_suffix(')').split(',')
	position = Vector2(pos[0], pos[1])
	previouslyConnected = dt.picked_up_connections
