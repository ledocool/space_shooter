extends Node2D
class_name UI

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var hpProgressBar = get_node("UICanvas/TopGUI/Layout/Hp/Layout/Bar");
#onready var ammoIcon = get_node("TopGUI/Layout/AmmoPanel/GunIcon");
onready var ammoLabel = get_node("UICanvas/TopGUI/Layout/AmmoPanel/AmmoCounter/AmmoLabel");
onready var speedLabel = get_node("UICanvas/TopGUI/Layout/AmmoPanel/Speed");
export var MinZoom = 1
export var MaxZoom = 1.7
export var ZoomSter = 0.1
export var CurrentZoom = 1

export var LeftCameraBorder = -100000000
export var TopCameraBorder = -100000000
export var BottomCameraBorder = 100000000
export var RightCameraBorder = 100000000

func _input(event):
	if(event.is_action("zoom_out")):
		SetZoom(GetZoom() - ZoomSter)
	if(event.is_action("zoom_in")):
		SetZoom(GetZoom() + ZoomSter)

func _ready():
	SetZoom(CurrentZoom)
	var camera = $Camera2D as Camera2D;
	if(camera):
		camera.set_limit(MARGIN_LEFT, LeftCameraBorder)
		camera.set_limit(MARGIN_RIGHT, RightCameraBorder)
		camera.set_limit(MARGIN_TOP, TopCameraBorder)
		camera.set_limit(MARGIN_BOTTOM, BottomCameraBorder)

func GetZoom():
	return CurrentZoom

func SetZoom(zoom: float):
	if(zoom > MaxZoom):
		CurrentZoom = MaxZoom
	elif(zoom < MinZoom):
		CurrentZoom = MinZoom
	else:
		CurrentZoom = zoom
	
	var z = Vector2(CurrentZoom, CurrentZoom)
	($Camera2D as Camera2D).set_zoom(z)

func _on_health_change(health):
	hpProgressBar.value = health;
	
func _on_max_health_change(maxHealth):
	hpProgressBar.max_value = maxHealth;
	
func _on_ammo_change(newAmmo, maxAmmo):
	ammoLabel.text = String(newAmmo) + "/" + String(maxAmmo);
	
func _on_speed_change(spd):
	speedLabel.text = String(spd)