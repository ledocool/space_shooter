extends Control

var regex = RegEx.new()
var oldText = ""

func _ready():
# warning-ignore:unsafe_method_access
	var size = $Background/MarginContainer.get_size()
	var splitContainer = $Background/MarginContainer/VSplitContainer/HSplitContainer
	var svButton = find_node("SaveButton")
	splitContainer.split_offset = size.x - svButton.get_size().x
	regex.compile("^[\\w\\-. ]+$")
	_updateSaveFileList()

func _unhandled_key_input(event):
	if(event.is_action_pressed("ui_menu")):
		if(self.visible):
			get_tree().set_input_as_handled()
		self.visible = false
	if(event.is_action_pressed("quick_save")):
		_quicksave()

func _quicksave():
# warning-ignore:unsafe_method_access
	$"/root/LevelLoader".SaveGame("quick.sav")
# warning-ignore:unsafe_method_access
	$"/root/OverlayLayer".ShowTimedNotificatiopn("quicksave_created", 0.7)

func _updateSaveFileList():
	var manager = SaveManager.new()
	var list = manager.GetSaveList()
# warning-ignore:unused_variable
	var buttonScene = load("res://scenes/interface/MenuButton.tscn")
# warning-ignore:unused_variable
	var saveContainer = self.find_node("SaveButtonsContainer")

	var loadContainer = self.find_node("SaveList")
	loadContainer.clear()
	for item in list:
		loadContainer.add_item(item)


func _on_NewSaveName_text_changed(new_text):
	if(regex.search(new_text) == null):
		var saveName = $Background/MarginContainer/VSplitContainer/HSplitContainer/VSplitContainer/NewSaveName
		var oldCaret = saveName.caret_position
		saveName.text = oldText
		saveName.caret_position = oldCaret
	else:
		oldText = new_text
		var btn = $Background/MarginContainer/VSplitContainer/HSplitContainer/Control/SaveButton
		btn.disabled = new_text == ""
	

func _populateTextbox(text):
	var saveNameEditor = find_node("NewSaveName")
	saveNameEditor.text = text
	_on_NewSaveName_text_changed(text)


func _on_SaveButton_pressed():
	var textEdit = self.find_node("NewSaveName")
	var saveName = textEdit.text
# warning-ignore:unsafe_method_access
	$"/root/LevelLoader".SaveGame(saveName)
	self.visible = false


func _on_SaveMenu_visibility_changed():
	var saveNameEditor = find_node("NewSaveName")
	saveNameEditor.text = ""
	var saveBtn = find_node("SaveButton")
	saveBtn.disabled = true


func _on_CloseButton_pressed():
	self.visible = false


func _on_NewSaveName_draw():
	_updateSaveFileList()


func _on_SaveList_item_activated(index):
	var loadContainer = self.find_node("SaveList")
	var saveName = ""
	saveName = loadContainer.get_item_text(index)
	_populateTextbox(saveName)

