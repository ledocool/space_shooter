extends Control

onready var SettingsMan = $"/root/SettingsManager"

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/MainVolume.SetSliderValue(\
		SettingsMan.GetVolume("Master"))
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/MusicVolume.SetSliderValue(\
		SettingsMan.GetVolume("Music"))
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/SfxVolume.SetSliderValue(\
		SettingsMan.GetVolume("Sfx"))

func _on_MainVolume_value_changed(newValue):
	SettingsMan.SetVolume("Master", newValue)


func _on_MusicVolume_value_changed(newValue):
	SettingsMan.SetVolume("Music", newValue)


func _on_SfxVolume_value_changed(newValue):
	SettingsMan.SetVolume("Sfx", newValue)
