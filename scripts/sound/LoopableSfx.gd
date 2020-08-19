extends Node2D

var MustPlay: bool = false

func Start():
	MustPlay = true
# warning-ignore:unsafe_method_access
	$Timer.stop()
# warning-ignore:unsafe_property_access
	if(!$AudioStreamPlayer2D.playing):
# warning-ignore:unsafe_method_access
		$AudioStreamPlayer2D.play()
	
func Stop():
	MustPlay = false
# warning-ignore:unsafe_method_access
	$Timer.start()
# warning-ignore:unsafe_method_access
	$AudioStreamPlayer2D2.play()
	

func _ready():
	pass

func _on_Timer_timeout():
	if(!MustPlay):
# warning-ignore:unsafe_method_access
		$AudioStreamPlayer2D.stop()
