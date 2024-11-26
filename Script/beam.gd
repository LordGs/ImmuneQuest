extends Area2D

var travelled_distance = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
func _ready():
	animated_sprite_2d.play("idle")
func _physics_process(delta):
	const SPEED = 100 #1000
	const RANGE = 20
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	print("hit")
	if body.has_method("take_damage"):
		body.take_damage()
