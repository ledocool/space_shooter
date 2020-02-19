extends Node2D
class_name WirePiece

func Enable():
# warning-ignore:unsafe_property_access
	$AnimatedSprite.frame = 1
	for child in $CollisionShape2D/Joint.get_children():
		if(child.has_method("Enable")):
			child.Enable()

func Disable():
# warning-ignore:unsafe_property_access
	$AnimatedSprite.frame = 0
	for child in $CollisionShape2D/Joint.get_children():
		if(child.has_method("Disable")):
			child.Disable()

func GetRightAnchor():
	return $RightAnchor
	
func GetLeftAnchor():
	return $LeftAnchor
	
func GetBody():
	return self
