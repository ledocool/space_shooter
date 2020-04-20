extends Node2D
class_name ShockPlate

export var Dps = 1

var intersectedEntities = []

export var modulateColor: Color
var sStep = 0
var vStep = 0
var hue = 0
var hurtful = false


func Save():
	return {
		"hurtful": hurtful,
		"h": hue,
		"v": modulateColor.v,
		"s": modulateColor.s,
		"a": modulateColor.a,
		"s_step": sStep,
		"v_step": vStep,
		"timeleft_become_hurtful": ($Timers/BecomeHurtfulTimer as Timer).time_left,
		"timeleft_hurtful": ($Timers/StayHurtfulTimer as Timer).time_left
	}


func Load(data: Dictionary):
	hurtful = data.hurtful
	sStep = data.s_step
	vStep = data.v_step
	modulateColor = Color.from_hsv(data.h, data.s, data.v, data.a)
	if(hurtful):
		($Timers/StayHurtfulTimer as Timer).set_wait_time(data.timeleft_hurtful)
	else:
		($Timers/BecomeHurtfulTimer as Timer).set_wait_time(data.timeleft_become_hurtful)


func _ready():	
	if(hurtful):
# warning-ignore:unsafe_property_access
		$Sprite.modulate = modulateColor
		($Timers/StayHurtfulTimer as Timer).start()
		($Timers/BecomeHurtfulTimer as Timer).stop()
# warning-ignore:unsafe_property_access
# warning-ignore:standalone_expression
# warning-ignore:unsafe_property_access
		$AnimatedSprite.visible = true
	else:
		($Timers/BecomeHurtfulTimer as Timer).start()
		
	var waitTime = ($Timers/BecomeHurtfulTimer as Timer).wait_time
	hue = modulateColor.h
	if(abs(sStep) > 1e-5):
		sStep = (modulateColor.s - 0) / waitTime
		modulateColor.s = 0
	if(abs(vStep) > 1e-5):
		vStep = (modulateColor.v - 1) / waitTime
		modulateColor.v = 1


func _physics_process(delta):
	if (hurtful):
		for body in intersectedEntities:
			body.Damage(Dps)
	else:
		modulateColor.h = hue
		modulateColor.s += sStep * delta
		modulateColor.v += vStep * delta 
# warning-ignore:unsafe_property_access
		$Sprite.modulate = modulateColor


func _on_BecomeHurtfulTimer_timeout():
# warning-ignore:unsafe_property_access
	$AnimatedSprite.visible = true
	($Timers/StayHurtfulTimer as Timer).start()
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
