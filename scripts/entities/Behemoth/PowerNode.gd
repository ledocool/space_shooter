extends StaticBody2D
class_name PowerNode

signal health_changed(oldHealth, newHealth)
signal exploded(position, size, rotation)

export var Health: int = 7
export var BulbChange: Array
export var BottomChange: Array
var MaxHealth = 7
var loaded = false

func Save() -> Dictionary:
	return {
		"Health": Health,
		"MaxHealth": MaxHealth
	}

func Load(data: Dictionary):
	loaded = true
	Health = data.Health

func _ready():
# warning-ignore:unsafe_method_access
	$LoopableGenerator.Start()
	if(loaded):
		_on_PowerNode_health_changed(MaxHealth, Health)
	var level = get_node_or_null("/root/Level")
	if(level != null):
		var _res
		_res = connect("health_changed", level, "_on_enemyHealth_change")


func GetHealth():
	return Health

func Damage(dmg: int):
	if(Health <= 0):
		return false
	
	var oldHealth = Health
	Health -= dmg
	
	if(Health <= 0):
# warning-ignore:unsafe_method_access
		$LoopableGenerator.Stop()
# warning-ignore:unsafe_method_access
		$BreakSound.play()
		emit_signal("exploded", self.position, Vector2(0.3, 0.3), 0)
		Health = 0
		
	emit_signal("health_changed", oldHealth, Health)
	return true


func _on_PowerNode_health_changed(_oldHealth, newHealth):
	if(newHealth == 0):
# warning-ignore:unsafe_method_access
		$Electricity.stop()
# warning-ignore:unsafe_property_access
		$Electricity.visible = false
	
	var bulbLastIndex = BulbChange.size() - 1
	var bodyLastIndex = BottomChange.size() - 1
	
	var accumulatedDamage = MaxHealth - newHealth
	for i in range(0, bulbLastIndex):
		if (BulbChange[i] <= accumulatedDamage && accumulatedDamage < BulbChange[i + 1]):
# warning-ignore:unsafe_property_access
			$Bulb.frame = i
	if(accumulatedDamage >= BulbChange[bulbLastIndex]):
# warning-ignore:unsafe_property_access
		$Bulb.frame = bulbLastIndex

	for i in range(0, bodyLastIndex):
		if (BottomChange[i] <= accumulatedDamage && accumulatedDamage < BottomChange[i + 1]):
# warning-ignore:unsafe_property_access
			$Bottom.frame = i
	if(accumulatedDamage >= BottomChange[bodyLastIndex]):
# warning-ignore:unsafe_property_access
		$Bottom.frame = bodyLastIndex
	
