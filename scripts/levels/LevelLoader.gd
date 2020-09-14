extends Node

var campaignLevelOrder: Array = [
	"res://scenes/levels/c1/c1l1.tscn",
	"res://scenes/levels/c1/c1l2.tscn"
]

var campaignCurrentLevel = -1
var saveManager = SaveManager.new()
var interactiveLoader = null
var loadScreen = preload("res://scenes/interface/LoadingScreen.tscn")
onready var popupScreen = $"/root/OverlayLayer"


var loadData = null
var lastLevelData = null

func SaveGame(fileName: String):
	saveManager.CreateSaveGame(fileName,
				$"/root/Level".get_filename(),
				campaignCurrentLevel,
				$"/root/Level".find_node("ShipContainer").get_children(),
				$"/root/Level".find_node("BulletContainer").get_children(),
				$"/root/Level".find_node("AsteroidContainer").get_children(),
				$"/root/Level".find_node("ItemContainer").get_children(),
				$"/root/Level".find_node("DynamicScenery").get_children(),
				$"/root/Level".find_node("TriggerContainer").get_children(),
# warning-ignore:unsafe_method_access
				$"/root/Level".GetStats())


func LoadGame(fileName: String, interactive: bool = true):
	var data = saveManager.LoadSaveGame(fileName)
	if(!data):
		print_debug("Could not parse savefile: " + fileName)
		popupScreen.ShowModal("Could not parse savefile: " + fileName);
		return
	
	if(interactive):
		loadData = data
		if(data.levelIndex >= 0):
			_getLevelByIndex(data.levelIndex, true)
		else:
			_getLevelByName(data.levelName, true)
	else:
		_loadSaveGameNonInteractive(data)


func LoadNextLevel(llData = null, interactive: bool = true):
	if(llData != null):
		lastLevelData = llData
	else:
		lastLevelData = _try_load_last_status(false)
		
	LoadLevel(campaignCurrentLevel + 1, interactive)


func LoadPrevLevel(interactive: bool = true):
	LoadLevel(campaignCurrentLevel - 1, interactive)


func LoadLevel(number: int, interactive: bool = true):
	var levelNode = _getLevelByIndex(number, interactive)
	if(levelNode):
		_swapCurrentScene(levelNode)
	return levelNode


func LoadLevelByName(name: String, interactive: bool = true):
	var levelNode = _getLevelByName(name, interactive)
	if(levelNode):
		_swapCurrentScene(levelNode)
	return levelNode


func ReloadLevel():
	var currentScene = get_tree().get_current_scene()
	lastLevelData = _try_load_last_status(true)
	LoadLevelByName(currentScene.get_filename())


func _try_load_last_status(reload: bool):
	var currentScene = get_tree().get_current_scene()
	if(currentScene.has_method("GetPlayerStatus")):
		return currentScene.GetPlayerStatus(reload)
		
	return null


func _init():
	set_pause_mode(Node.PAUSE_MODE_PROCESS)
	set_physics_process(false)


func _physics_process(_delta):
	if(interactiveLoader):
		var screen = _putUpLoadingScreen(interactiveLoader.get_stage(), interactiveLoader.get_stage_count())
		var pollResult = interactiveLoader.poll()
		if(pollResult == ERR_FILE_EOF):
			var scene = interactiveLoader.get_resource()
			var sceneInstance = scene.instance()
			
			if(loadData):
				_injectLoadedData(sceneInstance, loadData)
				loadData = null
			
			_swapCurrentScene(sceneInstance)
			interactiveLoader = null
			set_physics_process(false)
		elif (pollResult == OK):
			print_debug(String(interactiveLoader.get_stage()) + "/" + String(interactiveLoader.get_stage_count()))
			screen.SetCurrentStage(interactiveLoader.get_stage())
			pass


func _loadSaveGameNonInteractive(data: Dictionary):
	var levelScene
	if(data.levelIndex >= 0):
		levelScene = _getLevelByIndex(data.levelIndex, false)
	else:
		levelScene = _getLevelByName(data.levelName, false)
	var level = _injectLoadedData(levelScene, data)
	_swapCurrentScene(level)	


func _injectLoadedData(level: Level, data: Dictionary):
	var shipContainer = level.find_node("ShipContainer")
	var asteroidContainer = level.find_node("AsteroidContainer")
	var itemContainer = level.find_node("ItemContainer")
	var bulletContainer = level.find_node("BulletContainer")
	var sceneryContainer = level.find_node("DynamicScenery")
	var triggersContainer = level.find_node("TriggerContainer")
	level.SetStats(data.statistics)
	
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
	for trigger in triggersContainer.get_children():
		if(trigger.has_method("Load")):
			trigger.Load(data.triggers)
	
	return level


func _getLevelByName(name: String, interactive: bool):
	campaignCurrentLevel = -1
	if(interactive):
		return _getLevelInstanceInteractive(name)
	else:
		return _getLevelInstance(name)


func _getLevelByIndex(index: int, interactive: bool):
	if(index < 0 || index >= campaignLevelOrder.size()):
		print_debug("Level index not found:" + String(index))
		return null
	campaignCurrentLevel = index
	var levelSceneName = campaignLevelOrder[index]
	if(interactive):
		return _getLevelInstanceInteractive(levelSceneName)
	else:
		return _getLevelInstance(levelSceneName)


func _getLevelInstance(name: String):
	var level = load(name)
	var levelNode = level.instance()
	return levelNode


func _getLevelInstanceInteractive(name: String):
	interactiveLoader = ResourceLoader.load_interactive(name)
	set_physics_process(true)
	return null


func _putUpLoadingScreen(currentStage: int, stageCount: int):
	var screen = loadScreen.instance()
	screen.SetStageCount(currentStage, stageCount)
	_swapCurrentScene(screen)
	return screen


func _wipeNodeOfEntities(node: Node):
	for entity in node.get_children():
		node.remove_child(entity)
		entity.queue_free()


func _swapCurrentScene(scene: Node):
	var root = $"/root"
	var oldCurrentScene = get_tree().get_current_scene()
	
	if(scene.has_method("InjectPlayerStartStatus") 
		&& lastLevelData != null 
		&& lastLevelData is Dictionary):
# warning-ignore:unsafe_method_access
		scene.InjectPlayerStartStatus(lastLevelData)
		lastLevelData = null
		
	root.remove_child(oldCurrentScene)
	root.add_child(scene)
	get_tree().set_current_scene(scene)
	oldCurrentScene.queue_free()

