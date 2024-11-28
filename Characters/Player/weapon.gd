extends Area2D

@onready var player: CharacterBody2D = $".."
@onready var weapon_edge: Marker2D = %weapon_edge
@onready var hit_none: AudioStreamPlayer2D = $hit_none
@onready var joystick: Node2D = %joystick  # Assuming the joystick is a child of the player

var can_shoot = true

func _ready():
	# Any necessary setup here
	pass

func _physics_process(delta: float) -> void:
	# Get the direction from the joystick (which is the parent)
	var direction = joystick.get_direction()
	
	if direction.length() > 0.1:  # Only update if the joystick is moved enough
		rotation = direction.angle()
		
	# Check for attack input (single button)
	if Input.is_action_just_pressed("attack"):  # Replace with your single attack button action
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
