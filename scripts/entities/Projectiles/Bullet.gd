extends RigidBody2D
class_name Bullet

signal exploded(position, size, rotation)
signal damaged_something()

export var Damage = 1
var DamageMultiplier:float = 1.0

func _init(damage_multiplier = null):
	if(damage_multiplier != null):
		DamageMultiplier = damage_multiplier
		
func _ready():
	var level = get_node_or_null("/root/Level")
	if(level != null):
		var _res
		if(!is_connected("damaged_something", level, "_on_player_bullet_hit_target")):
			_res = connect("damaged_something", level, "_on_player_bullet_hit_target")
		level._on_player_shoot_something() #oh no, how bad!

func GetSpawnAnchorPosition():
	return ($SpawnAnchor as Node2D).position

func Save():
	return {
		"position": GetCoordinates(),
		"rotation": self.rotation,
		"velocity": GetVelocity(),
# warning-ignore:unsafe_method_access
		"lifetime": $Timers/Lifespan.get_time_left()
	}
	
func Load(data: Dictionary):
	var pos = data.position.trim_prefix('(').trim_suffix(')').split(',')
	var vel = data.velocity.trim_prefix('(').trim_suffix(')').split(',')
	self.position = Vector2(pos[0], pos[1])
	self.rotation = data.rotation
	self.linear_velocity = Vector2(vel[0], vel[1])
	($Timers/Lifespan as Timer).set_wait_time(data.lifetime)

func Destroy():
	emit_signal("exploded", self.position, 0.06, 0)
	queue_free()


func SpawnAt(pos: Vector2, angle: float, add_velocity: Vector2):
	var anchor = GetSpawnAnchorPosition().rotated(angle)
	rotation = angle
	linear_velocity = linear_velocity.rotated(rotation) + add_velocity
	self.position = pos - anchor

	
func Rotate(angle):
	self.rotation = angle
	

func GetDamage():
	return Damage * DamageMultiplier


func _on_Bullet_body_entered(body):
	if(body.has_method("Damage")):
		body.Damage(GetDamage())
		emit_signal("damaged_something")
	Destroy()


func GetCoordinates():
	return position

	
func GetVelocity():
	return linear_velocity


func _on_Lifespan_timeout():
	Destroy()
