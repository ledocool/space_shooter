extends Control

onready var SettingsMan = $"/root/SettingsManager"

export var supportedGraphicsModes: Array = [
	{
		"name": "windowed_setting",
		"func": "SetWindowWindowed"
	},
	{
		"name": "fullscreen_setting",
		"func": "SetWindowFullscreen"
	}
]
export var supportedResolutions: Array = [
	{
		"name": "1280x720",
		"size": Vector2(1280, 720)
	},
	{
		"name": "1366x768",
		"size": Vector2(1366, 768)
	},
	{
		"name": "1920x1080",
		"size": Vector2(1920, 1080)
	}
]


func _ready():
	var graphicsModes = []
	var modeSet = SettingsMan.GetWindowMode()
	var selectedMode = 0
	for mode in supportedGraphicsModes:
		graphicsModes.append(mode.name)
		if(modeSet == mode.name):
			selectedMode = graphicsModes.size() - 1
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/WindowModeDropdown.SetItems(graphicsModes)
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/WindowModeDropdown.SetSelected(selectedMode)
	
	
	var resolutions = []
	var resolution = SettingsMan.GetRenderResolution()
	var selectedResolution = 0
	for res in supportedResolutions:
		resolutions.append(res.name)
		if(res.size == resolution):
			selectedResolution = resolutions.size() - 1
			
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/ResolutionDropdown.SetItems(resolutions)
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/ResolutionDropdown.SetSelected(selectedResolution)


func _on_WindowModeDropdown_item_selected(id):
	if(id >= supportedGraphicsModes.size()):	
		return
	var mode = supportedGraphicsModes[id]
	SettingsMan.call(mode["func"])


func _on_ResolutionDropdown_item_selected(id):
	if(id >= supportedResolutions.size()):
		return
	var mode = supportedResolutions[id]
	SettingsMan.SetRenderResolution(mode["size"])


func _on_OptionsMenu_tree_exiting():
	SettingsMan.SaveConfiguration()


func _on_OptionsMenu_visibility_changed():
	SettingsMan.SaveConfiguration()
