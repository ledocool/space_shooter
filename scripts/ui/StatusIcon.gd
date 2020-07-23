extends Control

func _ready():
	$TextureRect.visible = false


func Show(blinkTime: float):
	$BlinkEnableTimer.start(blinkTime)
	$TextureRect.visible = true


func Hide():
	$BlinkTimer.stop()
	$BlinkEnableTimer.stop()
	$TextureRect.visible = false


func _on_BlinkTimer_timeout():
	$TextureRect.visible = !$TextureRect.visible


func _on_BlinkEnableTimer_timeout():
	$BlinkTimer.start()
