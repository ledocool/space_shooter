class_name AiAPathHelper


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


static func Track(targetPos: Vector2, targetVel: Vector2, selfPos: Vector2, selfVel: Vector2) -> Vector2:
	var pp = targetPos
	var relativeSpeed = targetVel + selfVel
	var fromThisToplayer = pp - selfPos
	
	var Difference = fromThisToplayer - relativeSpeed
	var angle = fromThisToplayer.angle_to(Difference)
	
	if(abs(angle) > 0.1745329 && abs(angle) < 1.396263): #0.1745329 = 10 degrees; 1.396263 = 80 degrees; 2.792527 = 160 deg
		return selfPos + Difference
	else:
		return pp;

static func TargetVisible(observerPos: Vector2, targetPos: Vector2, world: World2D):
	var space_state = Physics2DServer.space_get_direct_state(world.space)
	var intersected = space_state.intersect_ray(targetPos, observerPos, [], 524288)
	return intersected.empty()
