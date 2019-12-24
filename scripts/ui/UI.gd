extends Node2D
class_name UI

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var hpProgressBar = get_node("UICanvas/TopGUI/Layout/LeftStack/Hp/Layout/Bar");
#onready var ammoIcon = get_node("TopGUI/Layout/AmmoPanel/GunIcon");
onready var ammoLabel = get_node("UICanvas/TopGUI/Layout/AmmoPanel/AmmoCounter/AmmoLabel");
onready var speedProgress = get_node("UICanvas/TopGUI/Layout/LeftStack/Speed/Layout/Bar");
export var MinZoom = 1
export var MaxZoom = 1.7
export var ZoomStep = 0.1
export var CurrentZoom = 1

export var LeftCameraBorder = -100000000
export var TopCameraBorder = -100000000
export var BottomCameraBorder = 100000000
export var RightCameraBorder = 100000000

export var AutoZoomEnabled = false
export var AutoZoomSpeed = 0.9
export var CameraZooms: Dictionary = {
	190: 1,
	300: 1.3,
	600: 1.7
}

var SelectedZoom = 1
var AutoZoomStep = 0
var DoAutoZoom = false

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

func _input(event):
	if(event.is_action("zoom_out")):
		SetZoom(GetZoom() - ZoomStep)
		DoAutoZoom = false
	if(event.is_action("zoom_in")):
		SetZoom(GetZoom() + ZoomStep)
		DoAutoZoom = false

func _physics_process(delta):
	doAutoZoom(delta)

func _ready():
	SetZoom(CurrentZoom)
	var camera = $Camera2D as Camera2D;
	if(camera):
		camera.set_limit(MARGIN_LEFT, LeftCameraBorder)
		camera.set_limit(MARGIN_RIGHT, RightCameraBorder)
		camera.set_limit(MARGIN_TOP, TopCameraBorder)
		camera.set_limit(MARGIN_BOTTOM, BottomCameraBorder)

func _on_health_change(health):
	hpProgressBar.value = health;
	
func _on_max_health_change(maxHealth):
	hpProgressBar.max_value = maxHealth;
	
func _on_ammo_change(newAmmo, maxAmmo):
	ammoLabel.text = String(newAmmo) + "/" + String(maxAmmo);
	
func _on_speed_change(spd):
	speedProgress.value = spd
	var newThreshold = getZoomThresholdReached(spd)
	if(newThreshold):
		var NewSelectedZoom = CameraZooms[newThreshold]
		if(CurrentZoom - SelectedZoom < 1e-5 && AutoZoomEnabled):
			SelectedZoom = NewSelectedZoom
			AutoZoomStep = (NewSelectedZoom - GetZoom()) / AutoZoomSpeed
			DoAutoZoom = true
	
func _on_max_speed_change(maxSpd):
	speedProgress.max_value = maxSpd;
	
func getZoomThresholdReached(speed):
	var topThresh = null
	for thresh in CameraZooms:
		if(speed <= thresh):
			topThresh = thresh
			break;
	
	return topThresh
			
func doAutoZoom(delta):
	if(!DoAutoZoom):
		return;
	
	var zoom = GetZoom()
	zoom += AutoZoomStep*delta
	SetZoom(zoom)
	
	if(zoom - SelectedZoom < 1e-3):
		DoAutoZoom = false
		
		
		
		
		
		
		
		
		