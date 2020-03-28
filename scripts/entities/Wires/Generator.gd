extends StaticBody2D

signal wire_switch(isOn)

export var MaxHealth = 1
onready var health = MaxHealth


func Save():
	return {
		"position": position,
		"rotation": rotation,
		"health": health 
	}


func Load(data: Dictionary):
	var pos = data.position.trim_prefix('(').trim_suffix(')').split(',')
	position = Vector2(pos[0], pos[1])
	health = data.health
	self.rotation = data.rotation
	var spt = $AnimatedSprite as AnimatedSprite;
	if (spt != null):
		spt.frame = MaxHealth - health;


func Enable():
	emit_signal("wire_switch", true)
# warning-ignore:unsafe_method_access
	$Energy.show()
	($Glas_top as AnimatedSprite).frame = 0
	($Glas_bottom as AnimatedSprite).frame = 0;
	for child in $WireHitbox/Joint.get_children():
		if(child.has_method("Enable")):
			child.Enable()


func Disable():
	emit_signal("wire_switch", false)
# warning-ignore:unsafe_method_access
	$Energy.hide()
	($Glas_top as AnimatedSprite).frame = 1
	($Glas_bottom as AnimatedSprite).frame = 1;
	for child in $WireHitbox/Joint.get_children():
		if(child.has_method("Disable")):
			child.Disable()


func Damage(dmg):
	health -= dmg;
	if(health <= 0):
		Disable()
	else:
		Enable()
		
	return true
