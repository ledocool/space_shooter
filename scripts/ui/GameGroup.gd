extends Control

onready var SettingsMan = $"/root/SettingsManager"

var supportedLanguages = [
	{
		"name": "English",
		"locale": "en"
	},
	{
		"name": "Русский",
		"locale": "ru"
	}
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var langLocale = SettingsMan.GetLanguage()
	
	var langs = []
	var selectedLocale = -1
	var i = 0
	for locale in supportedLanguages:
		langs.append(locale.name)
		if(locale.locale == langLocale):
			selectedLocale = i
		i += 1
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/LanguageDropdown.SetItems(langs)
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/LanguageDropdown.SetSelected(selectedLocale)
	var autoZoom = SettingsMan.GetAutoZoom()
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/ZoomButton.set_pressed(autoZoom)
	var softcursor = SettingsMan.GetAutoZoom()
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/SoftwareCursor.set_pressed(softcursor)


func _on_LanguageDropdown_item_selected(id):
	if(id > supportedLanguages.size()):
		return
		
	var locale = supportedLanguages[id]
	SettingsMan.SetLanguage(locale.locale)


func _on_CheckButton_toggled(button_pressed):
	SettingsMan.SetAutoZoom(button_pressed)


func _on_SoftwareCursor_toggled(button_pressed):
	SettingsMan.SetSoftwareCursor(button_pressed)
