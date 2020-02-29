extends Node
class_name HealingStatus

var dead = false
var target = null

var healAmount = 10


func IsStatusDead():
	return dead


func _init(tg):
	target = tg


func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if(target.has_method("Heal")):
		target.Heal(healAmount)
		dead = true
