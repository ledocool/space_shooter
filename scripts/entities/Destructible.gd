extends RigidBody2D

signal exploded(position, size, rotation)

export var MaxHealth = 3
onready var health = MaxHealth

func _ready():
	var level: Level = $"/root/Level"
	connect("exploded", level, "_on_Something_explode")

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
		emit_signal("exploded", self.position, 1.2, 0)
		self.visible = false
		self.queue_free()
		
	return true
