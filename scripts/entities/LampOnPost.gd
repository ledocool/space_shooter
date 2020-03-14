extends Node2D

export var startupTime:float = 0
export var blinkTime:float = 0.7


func _ready():
	$RoundBlinkingLight/BlinkTimer.wait_time = blinkTime
	if(startupTime > 0):
		$RoundBlinkingLight/StartTimer.wait_time = startupTime
		$RoundBlinkingLight/StartTimer.start()
