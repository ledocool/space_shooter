extends Node2D

export var startupTime:float = 0
export var blinkTime:float = 0.7


func Stop():
# warning-ignore:unsafe_method_access
	$RoundBlinkingLight.Stop()


func _ready():
# warning-ignore:unsafe_property_access
	$RoundBlinkingLight/BlinkTimer.wait_time = blinkTime
	if(startupTime > 0):
# warning-ignore:unsafe_property_access
		$RoundBlinkingLight/StartTimer.wait_time = startupTime
# warning-ignore:unsafe_method_access
		$RoundBlinkingLight/StartTimer.start()
