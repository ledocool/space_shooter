extends Node2D

var minVal = -80
var maxVal = 0
var duration = 0.1

func Start():
	if(!$AudioStreamPlayer2D.playing):
		$AudioStreamPlayer2D.play()
	
func Stop():
	$AudioStreamPlayer2D.stop()

func _ready():
	pass
