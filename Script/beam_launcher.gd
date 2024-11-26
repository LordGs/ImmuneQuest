extends Area2D
@onready var player: CharacterBody2D = $".."

var direction = Vector2.DOWN
var can_shoot = true
@onready var sfx_shoot: AudioStreamPlayer2D = $sfx_shoot

func _physics_process(delta):
	
	if Input.is_action_just_pressed("shoot_up"):
		rotation_degrees = 270
		shoot()
	elif Input.is_action_just_pressed("shoot_down"):
		rotation_degrees = 90
		shoot()
	elif Input.is_action_just_pressed("shoot_left"):
		rotation_degrees = 180
		shoot()
	elif Input.is_action_just_pressed("shoot_right"):
		rotation_degrees = 0
		shoot()
	else:
		pass
	

func shoot():
	const BEAM = preload("res://Scenes/beam.tscn")

	if can_shoot:
		can_shoot = false
		var new_beam = BEAM.instantiate()
		new_beam.global_position = %shooting_point.global_position
		new_beam.global_rotation = %shooting_point.global_rotation
		%shooting_point.add_child(new_beam)
		sfx_shoot.play()
		# Start the cooldown timer
		$Timer.start()
func _on_timer_timeout() -> void:
	can_shoot = true
	
	
