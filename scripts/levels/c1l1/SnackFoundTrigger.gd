extends Area2D

var found = false

func Save():
	return {
		"snack_found": found
	}


func Load(data):
	found = data.snack_found


func _on_SnackFoundTrigger_body_entered(body):
	if(body is PlayerShip):
		if(!found):
# warning-ignore:unsafe_property_access
			$"/root/Level".playerSecretsFound += 1
			found = true
