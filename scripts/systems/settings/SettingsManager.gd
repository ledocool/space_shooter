extends Node

var mouseButtonNames = ["Left Mouse Button", "Right Mouse Button", "Mouse Wheel Up", "Mouse Wheel Down", "Mouse Wheel"]

func _init():
	pass
	
func _ready():
	pass # Replace with function body.

func SetVolume(bus: String, volume: float):
	var busIndex = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(busIndex, volume)
	
func GetVolume(bus: String) -> float:
	var busIndex = AudioServer.get_bus_index(bus)
	return AudioServer.get_bus_volume_db(busIndex)

func SetWindowFullscreen():
	OS.set_borderless_window(false)
	OS.set_window_fullscreen(true)
	
func SetWindowBorderless():
	OS.set_window_fullscreen(false)
	OS.set_borderless_window(true)
	
func SetWindowWindowed():
	OS.set_window_fullscreen(false)
	OS.set_borderless_window(false)
	
func GetWindowMode():
	pass
	
func SetRenderResolution(resolution: Vector2):
	OS.set_window_size(resolution)
	get_viewport().set_size_override(true, resolution, Vector2(0,0))
	
func GetRenderResolution():
	return OS.get_window_size()

func GetKey(name: String):
	var actionList = InputMap.get_action_list(name)
	for action in actionList:
		if(action is InputEventKey):
			return OS.get_scancode_string(action.get_scancode())
			
		if(action is InputEventMouseButton):
			if(action.button_index < mouseButtonNames.size()):
				return mouseButtonNames[action.button_index]
				
		if(action is InputEventJoypadButton):
			return "Button " + String(action.button_index)
		
	return "Unknown button"

func GetAllKeys():
	var actions = InputMap.get_actions()
	var returnArray = []
	for action in actions:
		returnArray.push_back({
				"action": action,
				"key": GetKey(action)
			})
	
	return returnArray

func SetAxis(name: String, event: InputEvent) -> bool:
	if(!event is InputEventJoypadMotion \
	&& !event is InputEventMouseMotion):
		return false
		
	InputMap.action_add_event(name, event)
	return true

func SetKey(name: String, event: InputEvent) -> bool:
	if(!event is InputEventJoypadButton \
	&& !event is InputEventKey \
	&& !event is InputEventMouseButton):
		return false
		
	InputMap.action_add_event(name, event)
	return true
	
	
func SetLanguage(locale):
	TranslationServer.set_locale(locale)
	
	
func GetLanguage():
	return TranslationServer.get_locale()
	
	
func _unsetControl(name: String):
	var actionList = InputMap.get_action_list(name)
	for e in actionList:
		InputMap.action_erase_event(name, e)
