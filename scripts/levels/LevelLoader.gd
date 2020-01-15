extends Node
class_name LevelLoader

var campaignLevelOrder: Array = [
	"res://scenes/levels/c1/c1l1.tscn"
]

var campaignCurrentLevel = -1
var saveManager = SaveManager.new()
var loadScreen = preload("res://scenes/interface/LoadingScreen.tscn")

func SaveGame(fileName: String):
	var stats = {
		"enemyHealthDamage": $"/root/Level".enemyHealthDamage,
		"playerHealthDamage": $"/root/Level".playerHealthDamage,
		"enemiesKilled": $"/root/Level".enemiesKilled,
		"playerShootsBullet": $"/root/Level".playerShootsBullet,
		"playerSecretsFound": $"/root/Level".playerSecretsFound
	}
	saveManager.CreateSaveGame(fileName,
				$"/root/Level".get_filename(),
				campaignCurrentLevel,
				$"/root/Level".find_node("ShipContainer").get_children(),
				$"/root/Level".find_node("BulletContainer").get_children(),
				$"/root/Level".find_node("AsteroidContainer").get_children(),
				$"/root/Level".find_node("ItemContainer").get_children(),
				$"/root/Level".find_node("DynamicScenery").get_children(),
				stats)
	pass


func LoadGame(fileName: String):
	var data = saveManager.LoadSaveGame(fileName)
	if(!data):
		print_debug("Could not parse savefile: " + fileName)
		return
	
	var levelScene
	if(data.levelIndex >= 0):
		levelScene = _getLevelByIndex(data.levelIndex)
	else:
		levelScene = _getLevelByName(data.levelName)
	var level = _injectLoadedData(levelScene, data)
	_swapCurrentScene(level)


func LoadNextLevel():
	LoadLevel(campaignCurrentLevel + 1)


func LoadPrevLevel():
	LoadLevel(campaignCurrentLevel - 1)


func LoadLevel(number: int):		
	var levelNode = _getLevelByIndex(number)
	if(levelNode):
		_swapCurrentScene(levelNode)
	return levelNode


func LoadLevelByName(name: String):
	var levelNode = _getLevelByName(name)
	if(levelNode):
		_swapCurrentScene(levelNode)
	return levelNode


func ReloadLevel():
	print_debug(get_tree().reload_current_scene())


func _init():
	pass


func _ready():
	pass # Replace with function body.


func _injectLoadedData(level: Level, data: Dictionary):
	var shipContainer = level.find_node("ShipContainer")
	var asteroidContainer = level.find_node("AsteroidContainer")
	var itemContainer = level.find_node("ItemContainer")
	var bulletContainer = level.find_node("BulletContainer")
	var sceneryContainer = level.find_node("DynamicScenery")
# warning-ignore:unsafe_property_access
	level.enemyHealthDamage = data.statistics.enemyHealthDamage
# warning-ignore:unsafe_property_access
	level.playerHealthDamage = data.statistics.playerHealthDamage
# warning-ignore:unsafe_property_access
	level.enemiesKilled = data.statistics.enemiesKilled
# warning-ignore:unsafe_property_access
	level.playerShootsBullet = data.statistics.playerShootsBullet
# warning-ignore:unsafe_property_access
	level.playerSecretsFound = data.statistics.playerSecretsFound
#	var camera = $"/root/Level".find_node("PlayerCamera")
	
	_wipeNodeOfEntities(shipContainer)
	_wipeNodeOfEntities(asteroidContainer)
	_wipeNodeOfEntities(itemContainer)
	_wipeNodeOfEntities(bulletContainer)
	_wipeNodeOfEntities(sceneryContainer)
	
	for ship in data.ships:
		shipContainer.add_child(ship)
		if(ship is PlayerShip):
			ship.name = "Player"
			var cameraAnchor = RemoteTransform2D.new()
			cameraAnchor.name = "CameraAnchor"
			cameraAnchor.use_global_coordinates = true
			cameraAnchor.update_rotation = false
			cameraAnchor.update_scale = false
			cameraAnchor.remote_path = "../../../PlayerCamera"
			ship.add_child(cameraAnchor)
	
	for asteroid in data.asteroids:
		asteroidContainer.add_child(asteroid)
	for bullet in data.bullets:
		bulletContainer.add_child(bullet)
	for item in data.items:
		itemContainer.add_child(item)
	for object in data.scenery:
		sceneryContainer.add_child(object)
	
	return level

func _getLevelByName(name: String):
	campaignCurrentLevel = -1
	return _getLevelInstance(name)
	
func _getLevelByIndex(index: int):
	if(index < 0 || index >= campaignLevelOrder.size()):
		print_debug("Level index not found:" + String(index))
		return null
	campaignCurrentLevel = index
	var levelSceneName = campaignLevelOrder[index]
	return _getLevelInstance(levelSceneName)


func _getLevelInstance(name: String):

	var level = load(name)
	var levelNode = level.instance()
	return levelNode

func _getLevelInstanceInteractive(name: String):
	var loader = ResourceLoader.load_interactive(name)
	var stageCount = loader.get_stage_count()
# warning-ignore:unused_variable
	var currentStage = loader.get_stage()
# warning-ignore:unused_variable
	var loadScren = _putUpLoadingScreen(stageCount)

func _putUpLoadingScreen(stageCount: int):
	var screen = loadScreen.instance()
	#screen.SetStageCount()
	_swapCurrentScene(screen)
	return screen

func _wipeNodeOfEntities(node: Node):
	for entity in node.get_children():
		node.remove_child(entity)
		entity.queue_free()

func _swapCurrentScene(scene: Node):
	var root = $"/root"
	var oldCurrentScene = get_tree().get_current_scene()
	root.remove_child(oldCurrentScene)
	root.add_child(scene)
	get_tree().set_current_scene(scene)
	oldCurrentScene.queue_free()
