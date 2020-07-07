extends Node2D
class_name Hideable

export var showSpeed = 0.5
export var hideSpeed = 0.3
var opacity = 1.0
var hide = false
var running = false

func _ready():
	setVisibility(opacity)

func _process(delta):
	if(!running):
		return
		
	if(hide == false && opacity < 1.0):
		opacity += delta * showSpeed
	elif(hide == true && opacity > 0.0):
		opacity -= delta * hideSpeed
	
	if(opacity < 0.0):
		opacity = 0.0
	elif(opacity > 1.0):
		opacity = 1.0
		
	setVisibility(opacity)

func Hide():
	hide = true
	running = true
	
func Show(): 
	hide = false
	visible = true
	running = true
	
func setVisibility(vis):
	if(vis > 1.0):
		vis = 1.0
	elif(vis < 0.0):
		vis = 0.0
		
	if(vis == 0):
		visible = false
	if(vis == 1 || vis == 0):
		running = false
		
	(material as ShaderMaterial).set_shader_param("visibility", vis)


func _on_VisibilityEnabler2D_screen_exited():
	if(hide):
		opacity = 0.0
	else:
		opacity = 1.0
	setVisibility(opacity)
