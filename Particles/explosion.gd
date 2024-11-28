extends Node2D

@onready var explode: CPUParticles2D = $CPUParticles2D
@onready var on_hit_sound: AudioStreamPlayer2D = $CPUParticles2D/on_hit_sound
@onready var explosion: AudioStreamPlayer2D = $CPUParticles2D/explosion

func _ready() -> void:
	explode.emitting = true
	on_hit_sound.play()
	explosion.play()
	await explode.finished
	self.queue_free()
	
