extends Node2D

export var Dps = 1

var intersectedEntities = []

export var modulateColor: Color
var sStep = 0
var vStep = 0
var hue = 0
var hurtful = false

func _ready():
	var waitTime = $Timers/BecomeHurtfulTimer.wait_time
	hue = modulateColor.h
	sStep = (modulateColor.s - 0) / waitTime
	vStep = (modulateColor.v - 1) / waitTime
	modulateColor.s = 0
	modulateColor.v = 1


func _physics_process(delta):
	if (hurtful):
		for body in intersectedEntities:
			body.Damage(Dps)
	else:
		modulateColor.h = hue
		modulateColor.s += sStep * delta
		modulateColor.v += vStep * delta 
		$Sprite.modulate = modulateColor


func _on_BecomeHurtfulTimer_timeout():
	$AnimatedSprite.visible = true
	($Timers/StayHurtfulTimer as Timer) .start()
	hurtful = true


func _on_StayHurtfulTimer_timeout():
	self.queue_free()


func _on_HurtZone_body_entered(body):
	if body is Ship && body.has_method("Damage"):
		intersectedEntities.append(body)


func _on_HurtZone_body_exited(body):
	var index = intersectedEntities.find(body)
	if(index  >= 0):
		intersectedEntities.remove(index)
