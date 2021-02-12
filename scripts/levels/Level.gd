extends WorldEnvironment
class_name Level

const Explosion = preload("res://scenes/effects/ExplosionEffect.tscn")
const Cursor = preload("res://resources/Ui/Icons/cursor.png")

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


func GetPlayer() -> PlayerShip:
	return $ShipContainer/Player as PlayerShip

func GetCamera() -> UI:
	return $PlayerCamera as UI

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
	_set_Crosshair(true)
	for layer in $Foreground.get_children():
# warning-ignore:unsafe_cast
		var multiplier = (layer as ParallaxLayer).motion_scale
		for object in layer.get_children():
			var pos: Vector2 = object.position
			pos.x *= multiplier.x
			pos.y *= multiplier.y
			object.position = pos


# warning-ignore:unused_argument
func _on_Ship_shoot(bullet, direction, location, velocity, damage_multiplier):
# warning-ignore:unsafe_cast
	if(!(bullet as Node).has_method("SpawnAt")):
		print_debug("Could not shoot bullet")
		return
		
	bullet.SpawnAt(location, direction, velocity)
	bullet.connect("exploded", self, "_on_Something_explode")
	$BulletContainer.call_deferred("add_child", bullet)

func _on_Ship_spawn(spawned):
	$DynamicScenery.call_deferred("add_child", spawned)


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
		gameWinMenu.SetData(dictionaryData)
		gameWinMenu.visible = true


func _on_EscapeMenu_save_game():
	var saveMenu = find_node("SaveMenu")
	saveMenu.visible = true


func _on_EscapeMenu_load_game():
	var loadMenu = find_node("LoadMenu")
	loadMenu.visible = true


func _on_EscapeMenu_options():
	var optionsMenu = find_node("OptionsMenu")
	optionsMenu.visible = true


func _set_Crosshair(enable: bool):
	if(enable):
		Input.set_custom_mouse_cursor(Cursor, 0, Vector2(64, 64));
	else:
		Input.set_custom_mouse_cursor(null);


func _on_EscapeMenu_visibility_changed():
	var saveMenu = find_node("EscapeMenu")
	_set_Crosshair(!saveMenu.visible)


func _on_Level_tree_exiting():
	_set_Crosshair(false)
