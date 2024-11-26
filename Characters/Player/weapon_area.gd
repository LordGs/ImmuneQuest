extends Area2D

@onready var attack_timer: Timer = $attack_timer
var travelled_distance = 0
func _ready() -> void:
	attack_timer.start()
	
func _physics_process(delta):
	const SPEED = 900 #1000
	const RANGE = 600
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_attack_timer_timeout() -> void:
	queue_free()
