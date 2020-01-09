extends RigidBody2D

export var MaxHealth = 3
onready var health = MaxHealth

func Save():
	return {
		"position": position,
		"rotation": rotation,
		"health": self.health 
	}
	
func Load(data: Dictionary):
	self.position = data.position
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