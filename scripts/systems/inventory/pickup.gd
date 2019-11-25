class_name Pickup

# type
## 0 - weapon
## 1 - ammo
## 2 - item

var type = 0
var quantity = 0
var name = ""
var info: Dictionary = {}

func set_type(t: int):
	type = t
	
func get_type():
	return type
	
func set_quantity(q: int):
	quantity = q
	
func get_quantity():
	return quantity
	
func set_name(n: String):
	name = n
	
func get_name():
	return name
	
func set_info(i: Dictionary):
	info = i
	
func get_info():
	return info
