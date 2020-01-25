extends Control

func _ready():
	pass

func SetMaxProgress(maxProgress: int):
	var progress = find_node("TextureProgress")
	progress.set_max(maxProgress)

func SetProgress(progress: int):
	var prog = find_node("TextureProgress")
	prog.value = progress
