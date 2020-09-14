extends CheatActor
class_name SpeedupActor

var Enabled = false

func Enable():
# warning-ignore:unsafe_cast
	var player = GetPlayer() as PlayerShip
	if(Enabled):
		return false
		
	if(player == null):
		print_debug("Player not found")
		return false
	
	_removeAllStatuses(player)
	player.SpeedMultiplier = 4.0
	Enabled = true
	return true
	
	
func Disable():
# warning-ignore:unsafe_cast
	var player = GetPlayer() as PlayerShip
	if(!Enabled):
		return false
		
	if(player == null):
		print_debug("Player not found")
		return false
	
	_removeAllStatuses(player)
	player.SpeedMultiplier = 1.0
	Enabled = false
	return true
	
	
func IsEnabled():
	return Enabled
	

func _removeAllStatuses(player: PlayerShip):
# warning-ignore:unsafe_property_access
	var statuses = player.StatusWrk.StatusArray
	for status in statuses:
# warning-ignore:unsafe_property_access
		player.StatusWrk.RemoveStatus(status)
