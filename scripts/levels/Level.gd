extends WorldEnvironment
class_name Level

const Explosion = preload("res://scenes/effects/ExplosionEffect.tscn")

#stats
var enemyHealthDamage = 0
var playerHealthDamage = 0
var enemiesKilled = 0
var playerShootsBullet = 0
var playerSecretsFound = 0
export var secretsMax = 0

var StartPlayerStatus = null

func InjectPlayerStartStatus(data: Dictionary):
	var Player = $ShipContainer/Player as Ship
	StartPlayerStatus = data
	if (Player):
		Player.SetInventory(data.get("inventory", {}))
		Player.SetMaxHealth(data.get("max_health", 0))
		Player.ShipCurrentHealth = data.get("health", 0)


func GetPlayerStatus(reload: bool = false):
	if(reload):
		return StartPlayerStatus
	
	var Player = $ShipContainer/Player as Ship
	if(!Player):
		return null
	return {
		"inventory": Player.GetInventory(),
		"health": Player.GetHealth(),
		"max_health": Player.GetMaxHealth()
	}


func GetPlayer():
	return $ShipContainer/Player


func SetStats(statistics: Dictionary):
	enemyHealthDamage = statistics.enemyHealthDamage
	playerHealthDamage = statistics.playerHealthDamage
	enemiesKilled = statistics.enemiesKilled
	playerShootsBullet = statistics.playerShootsBullet
	playerSecretsFound = statistics.playerSecretsFound
	StartPlayerStatus = statistics.get("playerStartStatus", null)


func GetStats():
	var stats = {
		"enemyHealthDamage": enemyHealthDamage,
		"playerHealthDamage": playerHealthDamage,
		"enemiesKilled": enemiesKilled,
		"playerShootsBullet": playerShootsBullet,
		"playerSecretsFound": playerSecretsFound,
		"playerStartStatus": StartPlayerStatus
	}
	return stats


func _ready():
	for shp in $ShipContainer.get_children():
		if(shp is Ship):
			print_debug("Connecting " + shp.get_name())
			shp.connect("exploded", self, "_on_Something_explode")
		if(shp is Turret):
			print_debug("Connecting " + shp.get_name())
			shp.connect("shoot_bullet", self, "_on_Ship_shoot")
			shp.connect("exploded", self, "_on_Something_explode")
			
	var Player = $ShipContainer/Player as PlayerShip
	if(Player):
		var camera = $PlayerCamera as UI
		Player.connect("health_changed", self, "_on_enemyHealth_change")
		Player.connect("health_changed", camera, "_on_health_change")
		Player.connect("health_changed", self, "_on_playerHealth_change")
		Player.connect("speed_changed", camera, "_on_speed_change")
		Player.connect("shoot_bullet", self, "_on_player_shootBullet")
		Player.connect("shoot_bullet", self, "_on_Ship_shoot")

		Player.get_node("Cannon").connect("bullets_changed", camera, "_on_ammo_change")
		Player.get_node("Cannon").connect("weapon_changed", camera, "_on_weapon_change")
		
		Player.connect("status_added", camera, "_on_status_add")
		Player.connect("status_removed", camera, "_on_status_remove")
		
		camera._on_max_health_change(Player.GetMaxHealth())
		camera._on_health_change(0, Player.GetHealth())
		camera._on_max_speed_change(Player.GetMaxSpeed())
		camera._on_speed_change(Player.GetVelocity().length())
		camera._on_ammo_change(Player.get_node("Cannon").RemainningAmmo)
		camera._on_weapon_change(Player.get_node("Cannon").CurrentWeapon)


# warning-ignore:unused_argument
func _on_Ship_shoot(bullet, direction, location, velocity, damage_multiplier):
# warning-ignore:unsafe_cast
	if(!(bullet as Node).has_method("SpawnAt")):
		print_debug("Could not shoot bullet")
		return
		
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
		call_deferred("_showGameLose")

func _showGameLose():
	var dictionaryData: Dictionary = {
			"shots_fired": playerShootsBullet,
			"damage_dealt": enemyHealthDamage,
			"enemies_killed": enemiesKilled,
			"accuracy": String(0) + "%",
			"secrets_found": String(playerSecretsFound) + "/" + String(secretsMax)
		}
	var gameLoseMenu = $MenuCanvas/MarginContainer/GameLoseMenu
	gameLoseMenu.SetData(dictionaryData)
	gameLoseMenu.visible = true

func _on_enemyHealth_change(oldhealth, health):
	if(oldhealth > health):
		enemyHealthDamage += oldhealth - health
	if(health <= 0):
		enemiesKilled += 1


func _on_player_shootBullet(_BulletType, _direction, _location, _velocity, _damage_multiplier):
	playerShootsBullet += 1


func _on_LevelEndTrigger_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if(body is PlayerShip):
		var dictionaryData: Dictionary = {
			"shots_fired": playerShootsBullet,
			"damage_dealt": enemyHealthDamage,
			"enemies_killed": enemiesKilled,
			"accuracy": String(0) + "%",
			"secrets_found": String(playerSecretsFound) + "/" + String(secretsMax)
		}
		var gameWinMenu = $MenuCanvas/MarginContainer/GameWinMenu
		gameWinMenu.SetData(dictionaryData, GetPlayerStatus())
		gameWinMenu.visible = true


func _on_EscapeMenu_save_game():
	var saveMenu = find_node("SaveMenu")
	saveMenu.visible = true


func _on_EscapeMenu_load_game():
	var loadMenu = find_node("LoadMenu")
	loadMenu.visible = true
