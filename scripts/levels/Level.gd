extends Node

const Explosion = preload("res://scenes/effects/ExplosionEffect.tscn")
#const Bullet = preload("res://scenes/entities/ConcreteEntities/Bullets/Bullet.tscn")

func _init():
	pass

func _ready():
	for shp in $ShipContainer.get_children():
		if(shp is Ship):
			print_debug("Connecting " + shp.get_name())
			print_debug(shp.connect("shoot_bullet", self, "_on_Ship_shoot"))
			print_debug(shp.connect("exploded", self, "_on_Something_explode"))
			
	var Player = $ShipContainer/Player as Ship
	if(Player):
		var camera = $PlayerCamera as UI
		print_debug(Player.connect("health_changed", camera, "_on_health_change"))
		print_debug(Player.connect("speed_changed", camera, "_on_speed_change"))
#		print_debug(Player.connect("bullets_changed", camera, "_on_ammo_change"))
		camera._on_max_health_change(Player.GetMaxHealth())
		camera._on_health_change(Player.GetHealth())
		camera._on_max_speed_change(Player.GetMaxSpeed())
		camera._on_ammo_change(0, 0)
	
func _on_Ship_shoot(BulletType, direction, location, velocity):
	var bullet = BulletType.instance()
	bullet.SpawnAt(location, direction, velocity)
	bullet.connect("exploded", self, "_on_Something_explode")
	$BulletContainer.add_child(bullet)
	
func _on_Something_explode(coordinates, explosionScale, rotation):
	var explosion = Explosion.instance()
	explosion.rotation = rotation
	explosion.scale = Vector2(explosionScale, explosionScale)
	explosion.position = coordinates
	$BulletContainer.add_child(explosion)
	explosion.get_node("AnimatedSprite").play()
	
func GetPlayer():
	return $ShipContainer/Player

func _on_LevelEndTrigger_body_shape_entered(_body_id, _body, _body_shape, _area_shape):
	pass # Replace with function body.
