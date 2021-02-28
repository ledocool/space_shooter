extends Node2D

func Stop():
# warning-ignore:unsafe_method_access
	$StartTimer.stop()
# warning-ignore:unsafe_method_access
	$BlinkTimer.stop()
	($Light as Light2D).enabled = false
# warning-ignore:unsafe_property_access
	$LightBulb.visible = false
# warning-ignore:unsafe_property_access
	$LightBulbOff.visible = true


# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:unsafe_property_access
	if($StartTimer.autostart):
# warning-ignore:unsafe_method_access
		$BlinkTimer.start()


func _on_BlinkTimer_timeout():
	($Light as Light2D).enabled = !($Light as Light2D).enabled
# warning-ignore:unsafe_property_access
	$LightBulb.visible = ($Light as Light2D).enabled
# warning-ignore:unsafe_property_access
	$LightBulbOff.visible = !($Light as Light2D).enabled


func _on_StartTimer_timeout():
# warning-ignore:unsafe_method_access
	$BlinkTimer.start()
