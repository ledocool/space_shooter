extends Node2D
class_name UI

onready var hpProgressBar = get_node("UICanvas/TopGUI/LeftStack/Hp/Layout/Bar");
onready var ammoLabel = get_node("UICanvas/TopGUI/AmmoPanel/AmmoLabel");
onready var speedProgress = get_node("UICanvas/TopGUI/LeftStack/Speed/Layout/Bar");
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
#		DoAutoZoom = false
	if(event.is_action("zoom_in")):
		SetZoom(GetZoom() + ZoomStep)
#		DoAutoZoom = false

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

func _on_health_change(_oldhealth, health):
	hpProgressBar.value = health;
	
func _on_max_health_change(maxHealth):
	hpProgressBar.max_value = maxHealth;
	
func _on_ammo_change(newAmmo):
	if(newAmmo >= 0):
		ammoLabel.visible = true
		ammoLabel.text = String(newAmmo)
	else:
		ammoLabel.visible = false
	
func _on_weapon_change(weapon):
	for child in $UICanvas/TopGUI/AmmoPanel/GunIcon.get_children():
		child.hide()
		
	ammoLabel.show()
	match weapon:
		"slug":
			($UICanvas/TopGUI/AmmoPanel/GunIcon/Slug as Control).show()
			ammoLabel.hide()
		"rocketeer":
			($UICanvas/TopGUI/AmmoPanel/GunIcon/Rocketeer as Control).show()
		_: 
			ammoLabel.hide()


func _on_status_add(status: String, pickup_timeout: float):
	var statusPanel = $UICanvas/TopGUI/StatusPanel
	var statusIcon = statusPanel.get_node(status)
	if(statusIcon && statusIcon.has_method("Show")):
		statusIcon.Show(pickup_timeout - 10)


func _on_status_remove(status: String):
	var statusPanel = $UICanvas/TopGUI/StatusPanel
	var statusIcon = statusPanel.get_node(status)
	if(statusIcon && statusIcon.has_method("Hide")):
		statusIcon.Hide()


func _on_speed_change(spd: float):
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
		
		
		
		
		
		
		
		
		
