extends Control


onready var Progress = $ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

func SetBossHealth(maxHealth, currentHealth):
	Progress.max_value = maxHealth
	Progress.value = currentHealth
	if(maxHealth != currentHealth):
		self.visible = true

func _on_boss_hp_change(_oldHealth, newHealth):
	self.visible = true
	Progress.value = newHealth
