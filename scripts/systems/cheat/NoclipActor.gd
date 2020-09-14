extends CheatActor
class_name NoclipActor

var Enabled = false

func Enable():
# warning-ignore:unsafe_cast
	var player = GetPlayer() as PlayerShip
	if(Enabled):
		return false
	
	if(player == null):
		print_debug("Player not found")
		return false
		
# warning-ignore:unsafe_cast
	var collision = player.get_node("CollisionShape2D") as CollisionShape2D
	collision.call_deferred("set_disabled", true)
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
		
# warning-ignore:unsafe_cast
	var collision = player.get_node("CollisionShape2D") as CollisionShape2D
	collision.call_deferred("set_disabled", false)
	Enabled = false
	return true	
	
	
func IsEnabled():
	return Enabled
	
