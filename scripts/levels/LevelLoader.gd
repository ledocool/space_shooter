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
		
	var levelScene = campaignLevelOrder[number]
	campaignCurrentLevel = number
	LoadLevelByName(levelScene)
	
func LoadPrevLevel():
	LoadLevel(campaignCurrentLevel - 1)
	
func ReloadLevel():
	print_debug(get_tree().reload_current_scene())
	
func LoadLevelByName(name: String):
	campaignCurrentLevel = -1
	var changed = get_tree().change_scene(name)
	print_debug("Change level to: " + name + ":" + String(changed))
	
