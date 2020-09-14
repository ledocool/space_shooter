extends Control

signal save_game()
signal load_game()
signal options()


var cheats: Array = []


func _ready():
	_on_EscapeMenu_visibility_changed()
	_add_cheat_entries()


func _unhandled_key_input(event):
	if(event.is_action_pressed("ui_menu")):
		self.visible = !self.visible
		get_tree().paused = self.visible


func _add_cheat_entries():
	var list: ItemList = $CheatMenu/MarginContainer/ItemList
	cheats.append({
		"name": "Invulnerability",
		"enabled": false,
		"actor": InvulnerabilityActor.new()
	})
	cheats.append({
		"name": "Destroy on bump",
		"enabled": false,
		"actor": DestroyOnBumpActor.new()
	})
	cheats.append({
		"name": "Speedup",
		"enabled": false,
		"actor": SpeedupActor.new()
	})
	cheats.append({
		"name": "Noclip",
		"enabled": false,
		"actor": NoclipActor.new()
	})
	
	for cheat in cheats:
		var level = $"/root/Level/"
		if(cheat.actor != null):
			cheat.actor.Init(level)
		list.add_item(cheat.name)

func _exit_tree():
	get_tree().paused = false


func _on_Resume_pressed():
	self.visible = false
	get_tree().paused = false


func _on_Save_game_pressed():
	emit_signal("save_game")


func _on_Load_game_pressed():
	emit_signal("load_game")


func _on_Options_pressed():
	emit_signal("options")


func _on_Exit_pressed():
# warning-ignore:return_value_discarded
	($"/root/LevelLoader" as LevelLoader).LoadLevelByName("res://scenes/interface/MainMenu.tscn", false)
	visible = false


func _on_EscapeMenu_visibility_changed():
	var pin = $CheatMenuEnabler/Pin
	pin.set_pickable(self.visible)
	pin.set_physics_process(self.visible)
	pin.set_process_input(self.visible)
# warning-ignore:unsafe_property_access
	$CheatMenu.visible = false


func _on_MenuButton_pressed():
# warning-ignore:unsafe_property_access
	$CheatMenu.visible = false
	for cheat in cheats:
		if (cheat.has("actor") && cheat.actor != null):
			cheat.actor.Switch(cheat.enabled)


func _on_ItemList_multi_selected(index, selected):
	if(cheats.size() <= index):
		return
	cheats[index].enabled = selected


func _on_Pin_pulledDown():
# warning-ignore:unsafe_property_access
	$CheatMenu.visible = true
# warning-ignore:unsafe_property_access
	$"CenterContainer/ItemList/Save game".visible = false
