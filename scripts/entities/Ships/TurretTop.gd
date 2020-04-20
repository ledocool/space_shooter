extends Node2D
class_name TurretPart

signal damaged(damage)

func Damage(dmg):
	emit_signal("damaged", dmg)


func GetCoordinates():
	return position


func GetRotation():
	return rotation


func GetVelocity(): 
	return Vector2.ZERO
