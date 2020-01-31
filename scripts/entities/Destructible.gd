extends RigidBody2D

export var MaxHealth = 3
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
	

func Damage(dmg):
	health -= dmg;
	if(health > 0):
		var spt = $AnimatedSprite as AnimatedSprite;
		if (spt != null):
			spt.frame = MaxHealth - health;
	else:
		self.visible = false
		self.queue_free()
