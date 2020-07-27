extends Node2D

var minVal = -80
var maxVal = 0
var duration = 0.1

func Start():
	$StartSoundTween.stop_all()
	if(!$AudioStreamPlayer2D.playing):
		$AudioStreamPlayer2D.play()
	
	var currentVolume = $AudioStreamPlayer2D.volume_db
	var currentDuration = duration * (maxVal - currentVolume) / (maxVal - minVal)
	
	$StartSoundTween.interpolate_property($AudioStreamPlayer2D, 
				"volume_db", currentVolume, maxVal, currentDuration)
				
	$StartSoundTween.start()
	$EndSoundTween.stop_all()
	
func Stop():
	$EndSoundTween.stop_all()
	var currentVolume = $AudioStreamPlayer2D.volume_db
	var currentDuration = duration * (currentVolume - minVal) / (maxVal - minVal)
	
	$EndSoundTween.interpolate_property($AudioStreamPlayer2D, 
				"volume_db", currentVolume, minVal, abs(currentDuration))
		
	$EndSoundTween.start()
	$StartSoundTween.stop_all()

func _ready():
	$AudioStreamPlayer2D.volume_db = -80

func _on_EndSoundTween_tween_completed(object, key):
	$AudioStreamPlayer2D.stop()
