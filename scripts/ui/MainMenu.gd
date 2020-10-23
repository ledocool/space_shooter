extends Control
	
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
