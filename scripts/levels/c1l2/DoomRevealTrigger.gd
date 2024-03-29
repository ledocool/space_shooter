extends Area2D

onready var secretAsteroids = get_tree().get_nodes_in_group("DoomChill")

var found = false

func Save():
	return {
		"doomguy_found": found
	}
	
func Load(data):
	found = data.doomguy_found

func _on_DoomRevealTrigger_body_entered(body):
	if(body is PlayerShip):
		if(!found):
# warning-ignore:unsafe_property_access
			$"/root/Level".playerSecretsFound += 1
			found = true
			
		for top in secretAsteroids:
			top.Hide();


func _on_DoomRevealTrigger_body_exited(body):
	if(body is PlayerShip):
		for top in secretAsteroids:
			top.Show();
