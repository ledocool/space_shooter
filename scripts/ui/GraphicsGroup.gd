extends Control

onready var SettingsMan = $"/root/SettingsManager"

export var supportedGraphicsModes: Array = [
	{
		"name":	"borderless_setting",
		"func": "SetWindowBorderless"
	},
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
		"name": "1366x768",
		"size": Vector2(1366, 768)
	},
	{
		"name": "1280x720",
		"size": Vector2(1280, 720)
	},
	{
		"name": "1920x1080",
		"size": Vector2(1920, 1080)
	}
]


func _ready():
	var graphicsModes = []
	for mode in supportedGraphicsModes:
		graphicsModes.append(mode.name)
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/WindowModeDropdown.SetItems(graphicsModes)
	
	var resolutions = []
	for res in supportedResolutions:
		resolutions.append(res.name)
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/ResolutionDropdown.SetItems(resolutions)


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
