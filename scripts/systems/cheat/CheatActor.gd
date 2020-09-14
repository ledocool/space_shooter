class_name CheatActor

var LevelInstance: WeakRef
var PlayerInstance: WeakRef


func Init(level):
	if(level is Level):
		LevelInstance = weakref(level)
		PlayerInstance = weakref(level.GetPlayer())

func GetPlayer():
	if(PlayerInstance == null):
		return null
	var ref = PlayerInstance.get_ref()
	if(!ref):
		return null
	return ref


func GetLevel():
	if(LevelInstance == null):
		return null
	var ref = LevelInstance.get_ref()
	if(!ref):
		return null
	return ref

func Switch(on: bool):
	if(on):
		return Enable()
	else:
		return Disable()


func Enable():
	pass
	
func Disable():
	pass
	
func IsEnabled():
	return false
