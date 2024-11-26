extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animation.play("idle")
