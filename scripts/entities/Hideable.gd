extends Node2D

export var showSpeed = 0.5
export var hideSpeed = 0.3
var opacity = 1.0
var hide = false

func _ready():
	if(Engine.is_editor_hint()):
		set_process(false)
		setVisibility(0.3)

##warning-ignore:unsafe_method_access
#	if(!$VisibilityEnabler2D.is_on_screen()):
#
#		set_process(false)
#		if(hide):
#			opacity = 0.0
#		else:
#			opacity = 1.0
#		setVisibility(opacity)

func _process(delta):
	if(hide == false && opacity >= 1.0
	|| hide == true && opacity <= 0.0):
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
	
func Show(): 
	hide = false
	
func setVisibility(vis):
	if(vis > 1.0):
		vis = 1.0
	elif(vis < 0.0):
		vis = 0.0
		
	if(vis == 0):
		visible = false
	(material as ShaderMaterial).set_shader_param("visibility", vis)


func _on_VisibilityEnabler2D_screen_exited():
	if(hide):
		opacity = 0.0
	else:
		opacity = 1.0
	setVisibility(opacity)
