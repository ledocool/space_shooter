extends Node2D

var MustPlay: bool = false

func Start():
	$AudioStreamPlayer2D.play()
	
func Stop():
	$AudioStreamPlayer2D.stop()
