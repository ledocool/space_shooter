extends Area2D

onready var secretAsteroids = get_tree().get_nodes_in_group("SecretCrevice")


func _on_SecretRevealTrigger_body_entered(body):
	if(body is PlayerShip):
		for top in secretAsteroids:
			print_debug(top.get_node("VisibilityEnabler2D").is_on_screen())
			top.Hide();


func _on_SecretRevealTrigger_body_exited(body):
	if(body is PlayerShip):
		for top in secretAsteroids:
			top.Show();
