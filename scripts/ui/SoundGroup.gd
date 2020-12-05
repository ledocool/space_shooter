extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/MainVolume.SetSliderValue(\
# warning-ignore:unsafe_method_access
		$"/root/SettingsManager".GetVolume("Master"))
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/MusicVolume.SetSliderValue(\
# warning-ignore:unsafe_method_access
		$"/root/SettingsManager".GetVolume("Music"))
# warning-ignore:unsafe_method_access
	$VBoxContainer/Contents/VBoxContainer/SfxVolume.SetSliderValue(\
# warning-ignore:unsafe_method_access
		$"/root/SettingsManager".GetVolume("Sfx"))

func _on_MainVolume_value_changed(newValue):
# warning-ignore:unsafe_method_access
	$"/root/SettingsManager".SetVolume("Master", newValue)


func _on_MusicVolume_value_changed(newValue):
# warning-ignore:unsafe_method_access
	$"/root/SettingsManager".SetVolume("Music", newValue)


func _on_SfxVolume_value_changed(newValue):
# warning-ignore:unsafe_method_access
	$"/root/SettingsManager".SetVolume("Sfx", newValue)
