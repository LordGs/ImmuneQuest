extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death: AudioStreamPlayer2D = $death

func _ready():
	death.play()

func _physics_process(delta):
	animated_sprite_2d.play("explode")
	await animated_sprite_2d.animation_finished
	queue_free()
