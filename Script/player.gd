extends CharacterBody2D

@onready var joystick: Node2D = %joystick
@onready var invincible_state_timer: Timer = $invincible_state_timer
@onready var damaged: AudioStreamPlayer2D = $sounds/damaged
@onready var right_footstep_sound: AudioStreamPlayer2D = $sounds/right_footstep
@onready var left_footstep_sound: AudioStreamPlayer2D = $sounds/left_footstep
@onready var collission: CollisionShape2D = $CollisionShape2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var attack_duration_timer: Timer = $attack_duration_timer
@onready var death_duration_timer: Timer = $death_duration
@onready var trail: Node2D = $trail

var SPEED = PlayerSystem.speed
var player_health = PlayerSystem.health
signal health_depleted
@onready var sprite = $AnimatedSprite2D
var invincible = false
var last_direction = "front"
var is_attacking = false
var saved_velocity = Vector2(0, 0)
var current_velocity = Vector2(0, 0)
var is_dead = false

var footstep_timer = 0.0
var footstep_interval = 0.33
var last_step = "right"

# Dash Variables
var dash_speed = 4000  # Dash speed multiplier
var dash_duration = 0.2  # Dash lasts for 0.2 seconds

var is_dashing = false
var can_dash = true
@onready var dash_timer: Timer = $dash_timer
@onready var dash_cooldown: Timer = $dash_cooldown

func _ready() -> void:
	trail.trail.emitting = false
	sprite.modulate = Color(1.1, 1.1, 1.1, 1)
	joystick.show()
	last_direction = "front"

func _physics_process(delta):
	var direction = joystick.posVector

	# Dash logic
	if is_dashing:
		# Dash using last_direction instead of joystick direction
		velocity = get_dash_direction() * dash_speed  # Dash in the direction of last_direction
		move_and_slide()  # Keep moving while dashing
		return  # Skip the rest of the physics processing during dash

	# Save current velocity (used for resuming movement after attack)
	if not is_attacking and not is_dead and not is_dashing:
		if direction:
			current_velocity = direction * SPEED

			# Handle footstep sounds
			footstep_timer += delta
			if footstep_timer >= footstep_interval:
				if last_step == "right":
					left_footstep_sound.play()
					last_step = "left"
				else:
					right_footstep_sound.play()
					last_step = "right"
				footstep_timer = 0.0
		else:
			current_velocity = Vector2(0, 0)

		# Move only if not attacking
		velocity = current_velocity
		move_and_slide()

		# Handle animations based on movement
		if direction != Vector2.ZERO:
			if abs(direction.x) > abs(direction.y):
				sprite.play("walk_side")
				sprite.flip_h = direction.x < 0
				last_direction = "right" if direction.x > 0 else "left"
			elif direction.y < 0:
				sprite.play("walk_back")
				last_direction = "up"
			else:
				sprite.play("walk_front")
				last_direction = "front"
		else:
			if last_direction == "front":
				sprite.play("idle_front")
			elif last_direction == "right" or last_direction == "left":
				sprite.play("idle_side")
			elif last_direction == "up":
				sprite.play("idle_back")

	var DAMAGE_RATE = PlayerSystem.self_damage
	var overlapping_mobs = %Hurtbox.get_overlapping_bodies()

	if overlapping_mobs.size() > 0:
		if not invincible:
			player_health -= DAMAGE_RATE
			invincible = true
			%ProgressBar.value = player_health
			# Damaged received
			sprite.modulate = Color(1.0, 0.5, 0.5, 0.8)
			damaged.play()
			invincible_state_timer.start()
			
			if player_health <= 0 and not is_dead:
				is_dead = true
				sprite.modulate = Color(1.1, 1.1, 1.1, 1)
				
				sprite.play("death")
				death_duration_timer.start()
				return  # Exit to prevent further processing

			if player_health <= -5.0:
				health_depleted.emit()
				joystick.hide()
				sprite.queue_free()
				get_node("../GameOver").game_over()
				print("you died")

func _on_invincible_state_timer_timeout() -> void:
	invincible = false
	sprite.modulate = Color(1.1, 1.1, 1.1, 1)

# Combined _input function for both attack and dash
func _input(event: InputEvent) -> void:
	# Handle attack input
	if event.is_action_pressed("attack") and not is_attacking and not is_dead:
		attack()

	# Handle dash input
	if event.is_action_pressed("dash") and not is_dashing and not is_dead:
		dash()

# Attack function
func attack():
	is_attacking = true
	velocity = Vector2(0, 0)

	# Determine the correct attack animation based on direction
	if last_direction == "front":
		sprite.play("attack_front")
	elif last_direction == "right" or last_direction == "left":
		sprite.play("attack_side")
		sprite.flip_h = (last_direction == "left")
	elif last_direction == "up":
		sprite.play("attack_back")

	# Start attack duration timer
	attack_duration_timer.start()

func _on_attack_duration_timer_timeout() -> void:
	is_attacking = false
	if not is_dead:
		velocity = current_velocity  # Resume movement based on joystick hold
		
@onready var dashsfx: AudioStreamPlayer2D = $sounds/dash

# Dash function
func dash():
	if can_dash == true:
		# Start the dash
		trail.trail.emitting = true
		is_dashing = true
		dashsfx.play()
		velocity = get_dash_direction() * dash_speed  # Dash using last_direction
		dash_timer.start()  # Start the dash timer to end the dash
		sprite.play("dash")  # Play dash animation
		sprite.modulate = Color(2, 2, 2, 1)
		can_dash = false
		

# Dash cooldown
func _on_dash_timer_timeout() -> void:
	is_dashing = false
	sprite.modulate = Color(1.1, 1.1, 1.1, 1)
	dash_cooldown.start()
	trail.trail.emitting = false
	velocity = current_velocity  # Resume normal velocity after dash

# Function to get the dash direction based on last_direction
func get_dash_direction() -> Vector2:
	if last_direction == "up":
		return Vector2(0, -1)  # Dash upwards
	elif last_direction == "right":
		return Vector2(1, 0)  # Dash to the right
	elif last_direction == "left":
		return Vector2(-1, 0)  # Dash to the left
	elif last_direction == "front":
		return Vector2(0, 1)  # Dash downwards
	return Vector2.ZERO  # Default to no direction if unknown


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
