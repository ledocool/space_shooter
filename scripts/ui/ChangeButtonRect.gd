extends ColorRect

signal button_changed(action, buttonName)

onready var SettingsMan = $"/root/SettingsManager"
var Action = null

func _ready():
	set_process_input(false)


func Show(action: String):
	visible = true
	Action = action


func _input(event):
	if(!visible || Action == null):
		return
	
	if(event is InputEvent && (event is InputEventMouseButton || event is InputEventKey)):
		if(event.is_pressed()):
			SettingsMan.SetKey(Action, event)
			accept_event()
			var button = SettingsMan.GetKey(Action)
			emit_signal("button_changed", Action, button)
			self.visible = false
			Action = null
			


func _on_ColorRect_visibility_changed():
	set_process_input(self.visible)
