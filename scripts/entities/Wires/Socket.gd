extends RigidBody2D

func Enable():
	for i in $CollisionShape2D/Joint.get_children():
		if(i.has_method("Enable")):
			i.Enable()
	
func Disable():
	for i in $CollisionShape2D/Joint.get_children():
		if(i.has_method("Disable")):
			i.Disable()
