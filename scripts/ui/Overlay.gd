extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func ShowModal(text: String):
# warning-ignore:unsafe_method_access
	find_node("Modal").Show(text)
