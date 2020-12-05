extends Control

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
# warning-ignore:unsafe_method_access
	var langLocale = $"/root/SettingsManager".GetLanguage()
	
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
	
	


func _on_LanguageDropdown_item_selected(id):
	if(id > supportedLanguages.size()):
		return
		
	var locale = supportedLanguages[id]
# warning-ignore:unused_variable
	var loaded = TranslationServer.get_loaded_locales()
# warning-ignore:unsafe_method_access
	$"/root/SettingsManager".SetLanguage(locale.locale)
