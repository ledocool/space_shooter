class_name StatusMap

const map = {
	"healing": "res://scripts/systems/status/HealingStatus.gd"
}

static func getStatusPath(name):
	return map[name]
