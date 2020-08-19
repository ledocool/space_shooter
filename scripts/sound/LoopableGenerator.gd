extends Node2D

var MustPlay: bool = false

func Start():
# warning-ignore:unsafe_method_access
	$AudioStreamPlayer2D.play()
	
func Stop():
# warning-ignore:unsafe_method_access
	$AudioStreamPlayer2D.stop()
