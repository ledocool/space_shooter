extends Control

func _ready():
# warning-ignore:unsafe_property_access
	$TextureRect.visible = false


func Show(blinkTime: float):
# warning-ignore:unsafe_method_access
	$BlinkEnableTimer.start(blinkTime)
# warning-ignore:unsafe_property_access
	$TextureRect.visible = true


func Hide():
# warning-ignore:unsafe_method_access
	$BlinkTimer.stop()
# warning-ignore:unsafe_method_access
	$BlinkEnableTimer.stop()
# warning-ignore:unsafe_property_access
	$TextureRect.visible = false


func _on_BlinkTimer_timeout():
# warning-ignore:unsafe_property_access
# warning-ignore:unsafe_property_access
	$TextureRect.visible = !$TextureRect.visible


func _on_BlinkEnableTimer_timeout():
# warning-ignore:unsafe_method_access
	$BlinkTimer.start()
