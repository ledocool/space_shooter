extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:unsafe_method_access
	$Label.hide()


func Show(text: String, duration: float = 1):
# warning-ignore:unsafe_property_access
	$Label.text = text
# warning-ignore:unsafe_method_access
	$Label.show()
# warning-ignore:unsafe_method_access
	$Timer.start(duration)

func Hide():
# warning-ignore:unsafe_method_access
	$Timer.stop()
# warning-ignore:unsafe_method_access
	$Label.hide()

func _on_Timer_timeout():
# warning-ignore:unsafe_method_access
	$Label.hide()
