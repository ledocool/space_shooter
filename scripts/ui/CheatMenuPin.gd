extends KinematicBody2D

signal pulledDown()

var isGrabbed = false
var isMouseOver = false
export var detectPressDistance = 300
export var detectDownY = 880
onready var startPosition = self.position

func _input(event):
	if(is_visible_in_tree() == false):
		return
	
	if (event is InputEventMouse):
		var distance = (event.position - startPosition).length()
		if(distance < detectPressDistance):
			isMouseOver = true
		else:
			isMouseOver = false
		
	if (event is InputEventMouseButton && event.button_index == BUTTON_LEFT):
		if(event.is_pressed() && isMouseOver):
			isGrabbed = true
		else:
			isGrabbed = false
			self.position = startPosition


func _physics_process(_delta):
	if(isGrabbed):
		var mousePosition = get_global_mouse_position()
		var speedVector = mousePosition - position
# warning-ignore:return_value_discarded
		move_and_slide(speedVector)
		if(position.y >= detectDownY):
			emit_signal("pulledDown")

