extends Node
class_name SaveManager

var SaveDirectory

func GetSaveList():
	SaveDirectory.list_dir_begin()
	var saves = Array()
	
	while true:
		var save = SaveDirectory.get_next()
		if(save == ""):
			break
		else:
			if(!save.begins_with(".")):
				saves.append(save)
				
	return saves

func LoadSaveGame(savename: String):
	var save = File.new()
	if(!savename.ends_with(".sav")):
		savename += ".sav"
	if(save.open("user://save/" + savename, File.READ) > 0):
		print_debug("Failed opening file: " + savename)
		return null
	var compressedSave = save.get_as_text()
	return _unserializeData(compressedSave)

func CreateSaveGame(savename: String, levelName: String, levelIndex: int, ships: Array, bullets: Array, asteroids: Array, scenery: Array, items: Array, triggers: Array, statistics: Dictionary):
	var savedata = _serializeData(levelName, levelIndex, ships, bullets, asteroids, items, scenery, triggers, statistics)
	var save = File.new()
	if(!savename.ends_with(".sav")):
		savename += ".sav"
	save.open("user://save/" + savename, File.WRITE)
	save.store_line(savedata)
	save.close()

func _init():
	SaveDirectory = Directory.new()
	if(SaveDirectory.open("user://save/") > 0):
		SaveDirectory.make_dir("user://save/")
		SaveDirectory.open("user://save/")

func _serializeData(levelName: String, levelIndex: int, ships: Array, bullets: Array, asteroids: Array, items: Array, scenery: Array, triggers: Array, statistics: Dictionary) -> String:
	var savedata = {
		"items": Array(),
		"bullets": Array(),
		"asteroids": Array(),
		"ships": Array(),
		"scenery": Array(),
#		"player": {},
		"levelName": levelName,
		"levelIndex": levelIndex,
		"statistics": statistics,
		"triggers": Dictionary()
	}
	
	for node in ships:
		var packed = _packNode(node)
		if(packed):
			savedata.ships.append(packed)
		
	for node in bullets:
		var packed = _packNode(node)
		if(packed):
			savedata.bullets.append(packed)
	
	for node in asteroids:
		var packed = _packNode(node)
		if(packed):
			savedata.asteroids.append(packed)
		
	for node in items:
		var packed = _packNode(node)
		if(packed):
			savedata.items.append(packed)
			
	for node in scenery:
		var packed = _packNode(node)
		if(packed):
			savedata.scenery.append(packed)
	
	for trigger in triggers:
		if(trigger.has_method("Save")):
			var data = trigger.Save()
			if(data):
				savedata.triggers = _merge(savedata.triggers, data)
	
	return to_json(savedata)

func _unserializeData(data: String):
	var validated = validate_json(data)
	if(validated != ""):
		print(validated)
		return null
	var uncompressedData = parse_json(data)
	if(typeof(uncompressedData) != TYPE_ARRAY && typeof(uncompressedData) != TYPE_DICTIONARY):
		return null
	
	var savedata = {
		"items": Array(),
		"bullets": Array(),
		"asteroids": Array(),
		"ships": Array(),
		"scenery": Array(),
#		"player": {},
		"statistics": uncompressedData.statistics,
		"levelName": uncompressedData.levelName,
		"levelIndex": uncompressedData.levelIndex,
		"triggers": uncompressedData.triggers
	}

	for object in uncompressedData.ships:
		var node = _unpackNode(object)
		if(node):
			savedata.ships.append(node)
		else:
			return null

	for object in uncompressedData.bullets:
		var node = _unpackNode(object)
		if(node):
			savedata.bullets.append(node)
		else:
			return null

	for object in uncompressedData.asteroids:
		var node = _unpackNode(object)
		if(node):
			savedata.asteroids.append(node)
		else:
			return null

	for object in uncompressedData.items:
		var node = _unpackNode(object)
		if(node):
			savedata.items.append(node)
		else:
			return null
			
	for object in uncompressedData.scenery:
		var node = _unpackNode(object)
		if(node):
			savedata.scenery.append(node)
		else:
			return null
			
	return savedata
	
func _packNode(node: Node):
	if(node.has_method("Save")):
		var d = {
			"name": node.get_filename(),
# warning-ignore:unsafe_method_access
			"value": node.Save(),
			"groups": node.get_groups()
		}
		return d
	
	return null

func _unpackNode(object: Dictionary):
	var packedScene = load(object.name) as PackedScene
	if(packedScene):
		var node = packedScene.instance()
		if(node.has_method("Load")):
			node.Load(object.value)
		for group in object.groups:
				node.add_to_group(group)
		
		return node
	
	return null


func _merge(d1: Dictionary, d2: Dictionary):
	for key in d2.keys():
		d1[key] = d2[key]
	return d1
