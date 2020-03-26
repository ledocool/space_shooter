extends Area2D

onready var secretAsteroids = get_tree().get_nodes_in_group("SecretCrevice")

var found = false

func _on_SecretRevealTrigger_body_entered(body):
	if(body is PlayerShip):
		if(!found):
# warning-ignore:unsafe_property_access
			$"/root/Level".playerSecretsFound += 1
			found = true
			
		for top in secretAsteroids:
			top.Hide();


func _on_SecretRevealTrigger_body_exited(body):
	if(body is PlayerShip):
		for top in secretAsteroids:
			top.Show();
