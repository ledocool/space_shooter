extends Node

var mouseButtonNames = ["_", "left_mouse_button", "right_mouse_button", "mouse_button_3", "mouse_wheel_up", "mouse_wheel_down", "mouse_button_4", "mouse_button_5"]
var CameraAutoZoomEnabled: bool
var SoftwareCursorEnabled: bool
var ConfigurationHandler: ConfigFile
var ConfigFileName = "./init.ini"


func SetAutoZoom(enabled: bool):
	ConfigurationHandler.get_value("misc", "autozoom", enabled)
	CameraAutoZoomEnabled = enabled


func GetAutoZoom():
	return CameraAutoZoomEnabled

func SetSoftwareCursor(enabled: bool):
	ConfigurationHandler.get_value("misc", "software_cursor", enabled)
	SoftwareCursorEnabled = enabled

func GetSoftwareCursor():
	return SoftwareCursorEnabled

func SetVolume(bus: String, volume: float):
	var busIndex = AudioServer.get_bus_index(bus)
	ConfigurationHandler.set_value("sound", bus, volume)
	var dbs = _percentageToDecibels(volume)
	AudioServer.set_bus_volume_db(busIndex, dbs)


func GetVolume(bus: String) -> float:
	var busIndex = AudioServer.get_bus_index(bus)
	var dbs = AudioServer.get_bus_volume_db(busIndex)
	return _decibelsToPercentage(dbs)

func _percentageToDecibels(volume: float):
	return linear2db(volume)
	

func _decibelsToPercentage(volume: float):
	return db2linear(volume)

func SetWindowFullscreen():
	ConfigurationHandler.set_value("display", "window_mode", "fullscreen")
	OS.set_borderless_window(false)
	OS.set_window_fullscreen(true)


func SetWindowBorderless():
	ConfigurationHandler.set_value("display", "window_mode", "borderless")
	OS.set_window_fullscreen(false)
	OS.set_borderless_window(true)


func SetWindowWindowed():
	ConfigurationHandler.set_value("display", "window_mode", "windowed")
	OS.set_window_fullscreen(false)
	OS.set_borderless_window(false)


func GetWindowMode():
	if(OS.is_window_fullscreen()):
		return "fullscreen_setting"
	else:
		if(OS.get_borderless_window()):
			return "borderless_setting"
		else:
			return "windowed_setting"


func SetRenderResolution(resolution: Vector2):
	ConfigurationHandler.set_value("display", "width", resolution.x)
	ConfigurationHandler.set_value("display", "height", resolution.y)
	OS.set_window_size(resolution)
	get_viewport().set_size(resolution)


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


func SetKey(actionName: String, event: InputEvent) -> bool:
	if(!event is InputEventJoypadButton \
	&& !event is InputEventKey \
	&& !event is InputEventMouseButton):
		return false
	
	#though shall not bind the escape key
# warning-ignore:unsafe_property_access
	if(event is InputEventKey && event.scancode == KEY_ESCAPE): 
		return false
	
	ConfigurationHandler.set_value("controls", actionName, event)
	
	_unsetControl(actionName)
	InputMap.action_add_event(actionName, event)
	return true


func SetLanguage(locale):
	ConfigurationHandler.set_value("misc", "language", locale)
	TranslationServer.set_locale(locale)


func SetCameraAutozoom(enable: bool):
	ConfigurationHandler.set_value("misc", "autozoom", enable)


func GetLanguage():
	return TranslationServer.get_locale()


func _unsetControl(name: String):
	var actionList = InputMap.get_action_list(name)
	for e in actionList:
		InputMap.action_erase_event(name, e)


func SaveConfiguration():
	var res = ConfigurationHandler.save(ConfigFileName)
	if(res != OK):
		print(res)


func _ready():
	_loadConfiguration()


func _init():
	ConfigurationHandler = ConfigFile.new()
	var err = ConfigurationHandler.load(ConfigFileName)
	if(err == ERR_FILE_NOT_FOUND):
		var res = ConfigurationHandler.save(ConfigFileName)
		if(res != OK):
			print(res)


func _loadConfiguration():
	if(ConfigurationHandler.has_section("sound")):
		var savedSound = ConfigurationHandler.get_section_keys("sound")
		for channel in savedSound:
			var volume = ConfigurationHandler.get_value("sound", channel)
			self.SetVolume(channel, volume)
	
	var locale = ConfigurationHandler.get_value("misc", "language", OS.get_locale())
	var localeList = TranslationServer.get_loaded_locales()
	if(localeList.find(locale) == -1):
		locale = localeList[0]
	self.SetLanguage(locale)
	
	var autozoom = ConfigurationHandler.get_value("misc", "autozoom", true)
	self.SetAutoZoom(autozoom)
	
	var softwareCursor = ConfigurationHandler.get_value("misc", "software_cursor", false)
	self.SetSoftwareCursor(softwareCursor)
	
	if(ConfigurationHandler.has_section("controls")):
		var savedControls = ConfigurationHandler.get_section_keys("controls")
		for action in savedControls:
			var event = ConfigurationHandler.get_value("controls", action)
			var _a = self.SetKey(action, event)
	
	var resolutionX = ConfigurationHandler.get_value("display", "width", 1920)
	var resolutionY = ConfigurationHandler.get_value("display", "height", 1080)
	self.SetRenderResolution(Vector2(resolutionX, resolutionY))
	
	var windowMode = ConfigurationHandler.get_value("display", "window_mode", "fullscreen")
	match windowMode:
		"fullscreen":
			self.SetWindowFullscreen()
		"windowed":
			self.SetWindowWindowed()
