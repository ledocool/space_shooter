extends Node
class_name SaveManager

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SaveDirectory = Directory.new()

func _init():
	if(SaveDirectory.open("user://save/") > 0):
		SaveDirectory.make_dir("user://save/")
		SaveDirectory.open("user://save/")

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
	
func LoadSaveGame():
	pass
	
func CreateSaveGame(savename: String, ships: Array, bullets: Array, asteroids: Array, items: Array, statistics: Dictionary):
	var savedata = SerializeData(ships, bullets, asteroids, items, statistics)
	var save = File.new()
	if(!savename.ends_with(".sav")):
		savename += ".sav"
	save.open("user://save/" + savename, File.WRITE)
	save.store_line(savedata)
	save.close()
	
	
func SerializeData(ships: Array, bullets: Array, asteroids: Array, items: Array, statistics: Dictionary):
#	var ships = Level.get_node("ShipContainer")
#	var bullets = Level.get_node("BulletContainer")
#	var asteroids = Level.get_node("AsteroidContainer")
#	var items = Level.get_node("ItemContainer")
	
	var savedata = {
		"items": Array(),
		"bullets": Array(),
		"asteroids": Array(),
		"ships": Array(),
		"player": {},
		"statistics": statistics
	}
	
	for node in ships:
		if(node.has_method("Save")):
			var d = {
				"name": node.get_filename(),
				"value": node.Save(),
				"groups": node.get_groups()
			}
			savedata.ships.append(d)
		
	for node in bullets:
		if(node.has_method("Save")):
			var d = {
				"name": node.get_filename(),
				"value": node.Save(),
				"groups": node.get_groups()
			}
			savedata.bullets.append(d)
		
	
	for node in asteroids:
		if(node.has_method("Save")):
			var d = {
				"name": node.get_filename(),
				"value": node.Save(),
				"groups": node.get_groups()
			}
			savedata.asteroids.append(d)
		
	for node in items:
		if(node.has_method("Save")):
			var d = {
				"name": node.get_filename(),
				"value": node.Save(),
				"groups": node.get_groups()
			}
			savedata.items.append(d)
	
	return to_json(savedata)
	