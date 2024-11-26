extends Area2D

@onready var player: CharacterBody2D = $".."
@onready var weapon_edge: Marker2D = %weapon_edge
@onready var hit_none: AudioStreamPlayer2D = $hit_none

var direction = Vector2.DOWN
var can_shoot = true

func _ready() -> void:
	self.show()

func _physics_process(delta):
	# Set direction and shoot based on input
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

func shoot():
	
	const BEAM = preload("res://Scenes/beam.tscn")

	if can_shoot:
		hit_none.play()
		can_shoot = false
		var new_beam = BEAM.instantiate()
		new_beam.global_position = weapon_edge.global_position
		new_beam.global_rotation = weapon_edge.global_rotation
		weapon_edge.add_child(new_beam)
		
		# Start the cooldown timer
		$attack_timer.start()

	


func _on_attack_timer_timeout() -> void:
	can_shoot = true
