extends Navigation2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var behemoth = get_node_or_null("../../ShipContainer/Behemoth") as Behemoth
	if(behemoth != null):
		behemoth.SetNavigator(self)
