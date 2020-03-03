tool
extends Node2D

export var showSpeed = 0.5
export var hideSpeed = 0.3
var visibility = 1.0
var hide = false

func _ready():
	if(Engine.is_editor_hint()):
		set_process(false)
		setVisibility(0.3)
		
# warning-ignore:unsafe_method_access
	if(!$VisibilityEnabler2D.is_on_screen()):
		set_process(false)

func _process(delta):
	if(hide == false && visibility < 1.0):
		visibility += delta * showSpeed
	elif(hide == true && visibility > 0.0):
		visibility -= delta * hideSpeed
		
	if(visibility < 0.0):
		visibility = 0.0
	elif(visibility > 1.0):
		visibility = 1.0
		
	if(hide == true && visibility > 0.0
		|| hide == false && visibility < 1.0):
		setVisibility(visibility)

func Hide():
	hide = true
	
func Show(): 
	hide = false
	
func setVisibility(vis):
	if(vis > 1.0):
		vis = 1.0
	elif(vis < 0.0):
		vis = 0.0
	(material as ShaderMaterial).set_shader_param("visibility", vis)

