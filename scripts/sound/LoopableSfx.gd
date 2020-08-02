extends Node2D

var MustPlay: bool = false

func Start():
	MustPlay = true
	$AudioStreamPlayer2D.volume_db = -15
	$Timer.stop()
	if(!$AudioStreamPlayer2D.playing):
		$AudioStreamPlayer2D.play()
	
func Stop():
	MustPlay = false
	$Timer.start()
	$AudioStreamPlayer2D2.play()
	

func _ready():
	pass

func _on_Timer_timeout():
	if(!MustPlay):
		$AudioStreamPlayer2D.stop()
