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
	$"/root/OverlayLayer".ShowTimedNotificatiopn("Quicksave created", 0.7)

func _updateSaveFileList():
	var manager = SaveManager.new()
	var list = manager.GetSaveList()
	var buttonScene = load("res://scenes/interface/MenuButton.tscn")
	var saveContainer = self.find_node("SaveButtonsContainer")
	
	#clean list first
	for item in saveContainer.get_children():
		saveContainer.remove_child(item)
		item.queue_free()

	for item in list:
		var newbtn = buttonScene.instance()
		newbtn.text = item
		saveContainer.add_child(newbtn)
		newbtn.connect("pressed_named", self, "_populateTextbox")

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


func _on_CloseButton_pressed():
	self.visible = false


func _on_NewSaveName_draw():
	_updateSaveFileList()
