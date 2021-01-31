extends Control

func _ready():
	var _res = ($BlackoutTween as Tween).interpolate_property($CanvasLayer/ColorRect, "color", 1.0, 0.0, 1.5)
	_res = ($BlackoutTween as Tween).start()
	
func _on_Exit_pressed():
	get_tree().quit()

func _on_Playground_pressed():
# warning-ignore:return_value_discarded
	($"/root/LevelLoader" as LevelLoader).LoadLevelByName("res://scenes/levels/Playground.tscn")

func _on_New_game_pressed():
	($"/root/LevelLoader" as LevelLoader).LoadLevel(0)
	

func _on_Load_game_pressed():
	var rightMenus = find_node("RightMenus")
	for node in rightMenus.get_children():
		node.visible = false
	
	var loadMenu = rightMenus.find_node("LoadMenu")
	loadMenu.visible = true


func _on_Credits_pressed():
	var rightMenus = find_node("RightMenus")
	for node in rightMenus.get_children():
		node.visible = false
		
	var creditsMenu = rightMenus.find_node("CreditsMenu")
	creditsMenu.visible = true


func _on_Quicktart_pressed():
	($"/root/LevelLoader" as LevelLoader).LoadLevel(1)


func _on_Options_pressed():
	var rightMenus = find_node("RightMenus")
	for node in rightMenus.get_children():
		node.visible = false
		
	var optionsMenu = rightMenus.find_node("OptionsMenu")
	optionsMenu.visible = true


func _on_Quicktart2_pressed():
	($"/root/LevelLoader" as LevelLoader).LoadLevel(2)


func _on_BlackoutTween_tween_all_completed():
	($CanvasLayer/ColorRect as Control).visible = false


func _on_BlackoutTween_tween_step(object, _key, _elapsed, value):
	var obj: Control = object
	var modul = obj.modulate
	modul.a = value
	obj.modulate = modul
