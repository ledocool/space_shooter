extends Control


var TotalStages = 0
var CurrentStage = 0

func SetStageCount(currentStage: int, totalStages: int):
	TotalStages = totalStages
	CurrentStage = currentStage
	
func SetCurrentStage(currentStage: int):
	CurrentStage = currentStage
	
func _setLoadLabel():
	var loadLabel = find_node("LoadLabel")
	loadLabel.text = String(CurrentStage) + "/" + String(TotalStages)
	
func _process(_delta):
	_setLoadLabel()
	