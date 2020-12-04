extends Control

onready var SettingsMan = $"/root/SettingsManager"

export var LabelWidth: float = 105
export var supportedGraphicsModes: Array = [
	{
		"name":	tr("borderless_setting"),
		"func": "SetWindowBorderless"
	},
	{
		"name": tr("windowed_setting"),
		"func": "SetWindowWindowed"
	},
	{
		"name": tr("fullscreen_setting"),
		"func": "SetWindowFullscreen"
	}
]
export var supportedResolutions: Array = [
	{
		"name": tr("1366x768"),
		"size": Vector2(1366, 768)
	},
	{
		"name": tr("1280x720"),
		"size": Vector2(1280, 720)
	},
	{
		"name": tr("1920x1080"),
		"size": Vector2(1920, 1080)
	}
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var graphicsModes = [];
	for mode in supportedGraphicsModes:
		graphicsModes.append(mode.name)
		
	$VBoxContainer/Contents/VBoxContainer/MarginContainer/WindowModeDropdown.SetItems(graphicsModes)
	
	for control in $VBoxContainer/Contents/VBoxContainer.get_children():
		for c in control.get_children():
			if(c is DropdownControl):
				c.SetLabelWidth(LabelWidth)

func _on_ResolutionButton_item_selected(id):
	if(id >= supportedResolutions.size()):	
		return
	var mode = supportedResolutions[id]
	SettingsMan.SetRenderResolution(mode["size"])


func _on_ModeButton_item_selected(id):
	if(id >= supportedGraphicsModes.size()):	
		return
	var mode = supportedGraphicsModes[id]
	SettingsMan.call(mode["func"])
