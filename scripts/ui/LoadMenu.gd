extends Control

func _ready():
# warning-ignore:unsafe_method_access
	var size = $Background/MarginContainer.get_size()
	var splitContainer = $Background/MarginContainer/VSplitContainer/HSplitContainer
	var svButton = find_node("LoadButton")
	splitContainer.split_offset = size.x - svButton.get_size().x
	_updateSaveFileList()

func _input(event):
	if(event.is_action_pressed("ui_menu")):
		if(self.visible):
			get_tree().set_input_as_handled()
		self.visible = false

func _updateSaveFileList():
# warning-ignore:unsafe_property_access
	var manager = ($"/root/LevelLoader" as LevelLoader).saveManager
	var list = manager.GetSaveList()
	var loadContainer = self.find_node("SaveList")
	
	loadContainer.clear()
	for item in list:
		loadContainer.add_item(item)

func _on_LoadButton_pressed():
	var loadContainer = self.find_node("SaveList")
	var selectedSave = loadContainer.get_selected_items()
	if(selectedSave.size() > 0):
		_loadLevelByindex(selectedSave[0])

func _loadLevelByindex(index):
	var loadContainer = self.find_node("SaveList")
	var saveName = ""
	saveName = loadContainer.get_item_text(index)
# warning-ignore:unsafe_method_access
	$"/root/LevelLoader".LoadGame(saveName)

func _on_SaveList_item_activated(index):
	_loadLevelByindex(index)

func _on_SaveList_item_selected(index):
	var btn =find_node("LoadButton")
	btn.disabled = index < 0
