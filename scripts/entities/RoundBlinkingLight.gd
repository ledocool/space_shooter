extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_BlinkTimer_timeout():
	($Light as Light2D).enabled = !($Light as Light2D).enabled
# warning-ignore:unsafe_property_access
	$LightBulb.visible = ($Light as Light2D).enabled
# warning-ignore:unsafe_property_access
	$LightBulbOff.visible = !($Light as Light2D).enabled
