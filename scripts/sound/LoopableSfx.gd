extends Node2D

var minVal = -80
var maxVal = 0
var duration = 0.1

func Start():
	$AudioStreamPlayer2D.volume_db = 0
	if(!$AudioStreamPlayer2D.playing):
		$AudioStreamPlayer2D.play()
	
func Stop():
	$AudioStreamPlayer2D.stop()
	$AudioStreamPlayer2D2.play(4.999)

func _ready():
	pass


func _on_Tween_tween_completed(object, key):
	if(object is AudioStreamPlayer2D):
		object.stop()


func _on_Tween_tween_step(object, key, elapsed, value):
	print_debug(value)


func _on_Tween_tween_started(object, key):
	pass # Replace with function body.
