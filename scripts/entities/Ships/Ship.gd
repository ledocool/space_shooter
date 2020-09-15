extends RigidBody2D
class_name Ship

signal health_changed(oldHealth, newHealth)
signal speed_changed(spd)
signal coordinates_changed(coords)
signal exploded(position, size, rotation)

export var ShipSpeed: float = 300
export var ShipTopSpeed: float = 900
export var ShipMaxHealth: int = 5 setget SetMaxHealth,GetMaxHealth
export var ShipCurrentHealth: int = 5 setget SetHealth,GetHealth
export var VelocityDampThreshold: float = 180

var SpeedMultiplier: float = 1
var ReceivedDamageMultiplier: float = 1

var Cursor = null
var EngineFiring: bool = false

var EngineFiringLastTime: bool = false

var OldSpeed = 0
var OldForce = Vector2(0,0)

func Damage(points: int):
	points = int(points * ReceivedDamageMultiplier)
	var cooldown = ($Timers/InvulnerabilityTimer as Timer)
	var blink = ($Timers/BlinkTimer as Timer)
	if(cooldown.is_stopped()):
		cooldown.start()
		blink.start()
		var oldShipHealth = ShipCurrentHealth
		ShipCurrentHealth = 0 if ShipCurrentHealth < points else ShipCurrentHealth - points
		emit_signal("health_changed", oldShipHealth, ShipCurrentHealth)
		return true
	return false


func Save():
	var data = {
		"position": position,
		"velocity": linear_velocity,
		"rotation": rotation,
		"health": ShipCurrentHealth,
		"max_health": ShipMaxHealth
	}
	return data


func Load(data: Dictionary):
	var pos = data.position.trim_prefix('(').trim_suffix(')').split(',')
	position = Vector2(pos[0], pos[1])
	var vel = data.velocity.trim_prefix('(').trim_suffix(')').split(',')
	linear_velocity = Vector2(vel[0], vel[1])
	rotation = data.rotation
	ShipCurrentHealth = data.health
	ShipMaxHealth = data.max_health

func Destroy():
	_onDestruction()
	self.queue_free()


func GetHealth() -> int:
	return ShipCurrentHealth


func GetMaxHealth() -> int:
	return ShipMaxHealth


func GetMaxSpeed() -> float:
	return ShipTopSpeed


func SetMaxHealth(value: int):
	ShipMaxHealth = value

func SetHealth(value: int):
	emit_signal("health_changed", ShipCurrentHealth,  value)
	ShipCurrentHealth = value


func Heal(points: int):
	var shipOldHealth = ShipCurrentHealth
	ShipCurrentHealth = ShipMaxHealth if ShipCurrentHealth + points > ShipMaxHealth else ShipCurrentHealth + points
	emit_signal("health_changed", shipOldHealth,  ShipCurrentHealth)


func GetCoordinates() -> Vector2:
	return position


func GetRotation() -> float:
	return rotation


func GetVelocity() -> Vector2: 
	return linear_velocity


func _integrate_forces(state):
	var oldRot = rotation
	
	if(Cursor != null):
		look_at(Cursor)
	var newRot = rotation
	if EngineFiringLastTime != EngineFiring:
		if EngineFiring:
# warning-ignore:unsafe_method_access
			$LoopableSfx.Start()
		else:
# warning-ignore:unsafe_method_access
			$LoopableSfx.Stop()
			
	_applySpeed(state, newRot, oldRot)


func _physics_process(_delta):
	if (ShipCurrentHealth <= 0):
		self.Destroy()
		return 0
	
	var spd = linear_velocity.length()
	if(spd < VelocityDampThreshold && EngineFiring == false):
		linear_damp = 5
	else:
		linear_damp = 0
	
	if(spd != OldSpeed):
		OldSpeed = spd
		emit_signal("speed_changed", spd)
	if(spd > 1e-6):
		emit_signal("coordinates_changed", position);


func _onDestruction():
	emit_signal("exploded", position, 0.15, 0)


func _playBoomSound():
	var boomSounds = $Sounds/Boom
	var childCound = boomSounds.get_child_count()
	var selectedNumber = randi() % childCound
	var boom = boomSounds.get_child(selectedNumber)
	if(boom is AudioStreamPlayer2D):
		boom.play()


func _applySpeed (state, newRot, oldRot):
	var force = Vector2(ShipSpeed * SpeedMultiplier, 0).rotated(newRot)
	
	if(newRot != oldRot || EngineFiringLastTime != EngineFiring):
		state.add_central_force(-OldForce)
		($EngineParticles as Particles2D).emitting = EngineFiring
		if(EngineFiring):
			state.add_central_force(force)
			OldForce = force
			if(state.linear_velocity.length_squared() > ShipTopSpeed * ShipTopSpeed):
				state.set_linear_velocity(state.get_linear_velocity().clamped(ShipTopSpeed))
		else:
			OldForce = Vector2(0,0)
			
		EngineFiringLastTime = EngineFiring


func _on_BlinkTimer_timeout():
	if(self.visible):
		self.hide()
	else:
		self.show()


func _on_InvulnerabilityTimer_timeout():
	var blink = $Timers/BlinkTimer as Timer
	blink.stop()
	self.show()



func _on_Ship_body_entered(_body):
	_playBoomSound()
