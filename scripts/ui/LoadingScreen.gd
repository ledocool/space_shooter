extends Control


var TotalStages = 0
var CurrentStage = 0

func SetStageCount(currentStage: int, totalStages: int):
	TotalStages = totalStages
	CurrentStage = currentStage
# warning-ignore:unsafe_method_access
	$CenterContainer/VBoxContainer/Progressbar.SetMaxProgress(TotalStages)
	
func SetCurrentStage(currentStage: int):
	CurrentStage = currentStage
	
func _process(_delta):
# warning-ignore:unsafe_method_access
	$CenterContainer/VBoxContainer/Progressbar.SetProgress(CurrentStage)
	