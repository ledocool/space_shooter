class_name AiAPathHelper


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


static func Track(targetPos: Vector2, targetVel: Vector2, selfPos: Vector2, selfVel: Vector2, soft: bool = false) -> Vector2:
	var relativeSpeed = targetVel + selfVel
	var fromThisToTarget = targetPos - selfPos
	
	if(!soft && fromThisToTarget.length_squared() < relativeSpeed.length_squared()):
		fromThisToTarget = Vector2(relativeSpeed.length() * 2, 0).rotated(fromThisToTarget.angle())
	
	var Difference = fromThisToTarget - relativeSpeed	
	return Difference

static func TargetVisible(observerPos: Vector2, targetPos: Vector2, world: World2D):
	var space_state = Physics2DServer.space_get_direct_state(world.space)
	var intersected = space_state.intersect_ray(targetPos, observerPos, [], 524288)
	return intersected.empty()
