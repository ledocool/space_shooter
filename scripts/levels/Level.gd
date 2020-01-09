extends WorldEnvironment
class_name Level

const Explosion = preload("res://scenes/effects/ExplosionEffect.tscn")
#const Bullet = preload("res://scenes/entities/ConcreteEntities/Bullets/Bullet.tscn")

#stats
var enemyHealthDamage = 0
var playerHealthDamage = 0
var enemiesKilled = 0
var playerShootsBullet = 0
# warning-ignore:unused_class_variable
var playerSecretsFound = 0
# warning-ignore:unused_class_variable
var secretsMax = 0

func GetPlayer():
	return $ShipContainer/Player

func _init():
	pass

func _ready():
	for shp in $ShipContainer.get_children():
		if(shp is Ship):
			print_debug("Connecting " + shp.get_name())
			shp.connect("shoot_bullet", self, "_on_Ship_shoot")
			shp.connect("exploded", self, "_on_Something_explode")
			if(!shp is PlayerShip):
				shp.connect("health_changed", self, "_on_enemyHealth_change")
			
	var Player = $ShipContainer/Player as Ship
	if(Player):
		var camera = $PlayerCamera as UI
		Player.connect("health_changed", camera, "_on_health_change")
		Player.connect("health_changed", self, "_on_playerHealth_change")
		Player.connect("speed_changed", camera, "_on_speed_change")
		Player.connect("shoot_bullet", self, "_on_player_shootBullet")
#		print_debug(Player.connect("bullets_changed", camera, "_on_ammo_change"))
		camera._on_max_health_change(Player.GetMaxHealth())
		camera._on_health_change(0, Player.GetHealth())
		camera._on_max_speed_change(Player.GetMaxSpeed())
		camera._on_speed_change(0)
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
	$Scenery.add_child(explosion)
	explosion.get_node("AnimatedSprite").play()
	
func _on_playerHealth_change(oldhealth, health):
	if(oldhealth > health):
		playerHealthDamage += oldhealth - health
	if(health <= 0):
		var dictionaryData: Dictionary = {
			"shots_fired": playerShootsBullet,
			"damage_dealt": enemyHealthDamage,
			"enemies_killed": enemiesKilled,
			"accuracy": String(0) + "%",
			"secrets_found": String(self.playerSecretsFound) + "/" + String(self.secretsMax)
		}
		var gameLoseMenu = $MenuCanvas/MarginContainer/GameLoseMenu
		gameLoseMenu.SetData(dictionaryData)
		gameLoseMenu.visible = true

func _on_enemyHealth_change(oldhealth, health):
	if(oldhealth > health):
		enemyHealthDamage += oldhealth - health
	if(health <= 0):
		enemiesKilled += 1

func _on_player_shootBullet(_BulletType, _direction, _location, _velocity):
	playerShootsBullet += 1

func _on_LevelEndTrigger_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if(body is PlayerShip):
		var dictionaryData: Dictionary = {
			"shots_fired": playerShootsBullet,
			"damage_dealt": enemyHealthDamage,
			"enemies_killed": enemiesKilled,
			"accuracy": String(0) + "%",
			"secrets_found": String(self.playerSecretsFound) + "/" + String(self.secretsMax)
		}
		var gameWinMenu = $MenuCanvas/MarginContainer/GameWinMenu
		gameWinMenu.SetData(dictionaryData)
		gameWinMenu.visible = true

func _on_EscapeMenu_save_game():
	var saveMenu = find_node("SaveMenu")
	saveMenu.visible = true

func _on_SaveMenu_save_requested(fileName: String):
	var manager = SaveManager.new()
	var stats = {
		"enemyHealthDamage": enemyHealthDamage,
		"playerHealthDamage": playerHealthDamage,
		"enemiesKilled": enemiesKilled,
		"playerShootsBullet": playerShootsBullet,
		"playerSecretsFound": playerSecretsFound,
		"secretsMax": secretsMax
	}
	manager.CreateSaveGame(fileName, 
				self.find_node("ShipContainer").get_children(),
				self.find_node("BulletContainer").get_children(),
				self.find_node("AsteroidContainer").get_children(),
				self.find_node("ItemContainer").get_children(),
				stats)

func _on_load_requested(ships: Array, asteroids: Array, bullets: Array, items: Array):
	var shipContainer = find_node("ShipContainer")
	var asteroidContainer = find_node("AsteroidContainer")
	var itemContainer = find_node("ItemContainer")
	var bulletContainer = find_node("BulletContainer")
# warning-ignore:unused_variable
	var camera = find_node("PlayerCamera")
	
	_wipeLevelOfEntities()
	
	for ship in ships:
		shipContainer.add_child(ship)
		if(ship is PlayerShip):
			var cameraAnchor = RemoteTransform2D.new()
			cameraAnchor.name = "CameraAnchor"
			cameraAnchor.use_global_coordinates = true
			cameraAnchor.update_rotation = false
			cameraAnchor.update_scale = false
			cameraAnchor.remote_path = "../../../PlayerCamera"
			ship.add_child(cameraAnchor)
	
	for asteroid in asteroids:
		asteroidContainer.add_child(asteroid)
	
	for bullet in bullets:
		bulletContainer.add_child(bullet)
		
	for item in items:
		itemContainer.add_child(item)

func _wipeLevelOfEntities():
	var shipContainer = find_node("ShipContainer")
	var asteroidContainer = find_node("AsteroidContainer")
	var itemContainer = find_node("ItemContainer")
	var bulletContainer = find_node("BulletContainer")
# warning-ignore:unused_variable
	var camera = find_node("PlayerCamera")
	
	for ship in shipContainer.get_children():
		shipContainer.remove_child(ship)
		ship.queue_free()
		
	for asteroid in asteroidContainer.get_children():
		asteroidContainer.remove_child(asteroid)
		asteroid.queue_free()
		
	for bullet in bulletContainer.get_children():
		bulletContainer.remove_child(bullet)
		bullet.queue_free()
		
	for item in itemContainer.get_children():
		itemContainer.remove_child(item)
		item.queue_free()
