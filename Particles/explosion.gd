extends Node2D

@onready var explode: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	explode.emitting = true
	await explode.finished
	self.queue_free()
	
