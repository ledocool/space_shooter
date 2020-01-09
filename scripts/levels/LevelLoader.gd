extends Node
class_name LevelLoader

var campaignLevelOrder: Array = [
	"res://scenes/levels/c1/c1l1.tscn"
]

var campaignCurrentLevel = -1


func _init():
	pass

func _ready():
	pass # Replace with function body.

func LoadNextLevel():
	LoadLevel(campaignCurrentLevel + 1)
	
func LoadLevel(number: int):
	if(number < 0 || number >= campaignLevelOrder.size()):
		print_debug("Level index not found:" + String(number))
		return
		
	var levelSceneName = campaignLevelOrder[number]
	var changedTo = LoadLevelByName(levelSceneName)
	campaignCurrentLevel = number
	return changedTo
	
func LoadPrevLevel():
	LoadLevel(campaignCurrentLevel - 1)
	
func ReloadLevel():
	print_debug(get_tree().reload_current_scene())
	
func LoadLevelByName(name: String) -> PackedScene:
	campaignCurrentLevel = -1
	var level = load(name)
	var changed = get_tree().change_scene_to(level)
	print_debug("Change level to: " + name + ":" + String(changed))
	return level

func SaveGame():
	pass
	
func LoadGame():
	pass
	
