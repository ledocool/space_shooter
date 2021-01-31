extends Control

export var Action: String = ""
var AssignedButton

var IsMouseButtonIn = false

onready var KeyLabel = $HBoxContainer/Button/Label
onready var KeyButton = $HBoxContainer/Button
onready var KeyAction = $HBoxContainer/Action


func _ready():
	KeyAction.text = Action
	var assignedButton = ($"/root/SettingsManager" as SettingsManager).GetKey(Action)
	KeyLabel.text = assignedButton


func _unhandled_input(event):
	if (IsMouseButtonIn == true):
		if(event is InputEventMouseButton):
			if(event.button_index == 1 && event.is_doubleclick()):
				accept_event()
				_call_set_btn()


func _call_set_btn():
# warning-ignore:unsafe_method_access
	$"/root/OverlayLayer".ShowChangeBtnPopup(Action)
	var data = yield($"/root/OverlayLayer".get_node("ChangeBtnWrapper/ChangeBtnPopup"), "button_changed")
	KeyLabel.text = data[1]


func _on_Button_mouse_entered():
	IsMouseButtonIn = true


func _on_Button_mouse_exited():
	IsMouseButtonIn = false
