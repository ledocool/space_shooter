extends Node2D

signal damaged(damage)

func Damage(dmg):
	emit_signal("damaged", dmg)
