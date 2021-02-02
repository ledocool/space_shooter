extends Node2D

var TextReplacement
onready var SettingsMan = $"/root/SettingsManager"

func _ready():
	TextReplacement = ($RichTextLabel as RichTextLabel).text
	Translate()

func Translate():
	var insertage = InsertInString(tr(TextReplacement))
	($RichTextLabel as RichTextLabel).text = insertage

func InsertInString(string: String) -> String:
	var index = string.find_last("{")
	while (index != -1):
		var lastIndex = string.find("}", index)
		var action = string.substr(index, lastIndex - index + 1)
		action = action.trim_prefix("{").trim_suffix("}")
		var substitution = SettingsMan.GetKey(action)
		var sub = tr(substitution)
		string.erase(index, lastIndex - index + 1)
		string = string.insert(index, sub)
		index = string.find_last("{")
	
	return string

