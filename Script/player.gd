extends CharacterBody2D

@onready var joystick: Node2D = %joystick
@onready var invincible_state_timer: Timer = $invincible_state_timer
@onready var damaged: AudioStreamPlayer2D = $sounds/damaged
@onready var right_footstep_sound: AudioStreamPlayer2D = $sounds/right_footstep
@onready var left_footstep_sound: AudioStreamPlayer2D = $sounds/left_footstep

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var attack_duration_timer: Timer = $attack_duration_timer
@onready var death_duration_timer: Timer = $death_duration

var SPEED = PlayerSystem.speed
var player_health = PlayerSystem.health
signal health_depleted
@onready var sprite = $AnimatedSprite2D
var invincible = false
var last_direction = "front"
var is_attacking = false  # State variable to track attacking
var saved_velocity = Vector2(0, 0)  # Store player's velocity during attack
var current_velocity = Vector2(0, 0)  # Track current velocity during movement
var is_dead = false  # Flag to indicate if the player is dead

var footstep_timer = 0.0  # Timer to track footstep timing
var footstep_interval = 0.33  # Interval in seconds between footstep sounds
var last_step = "right"  # Track the last step taken

func _ready() -> void:
	joystick.show()
	last_direction = "front"

func _physics_process(delta):
	var direction = joystick.posVector

	# Save current velocity (used for resuming movement after attack)
	if not is_attacking and not is_dead:  # Prevent movement if dead
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
				sprite.flip_h = direction.x < 0  # Flip sprite if moving left
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
			
			# Check for health depletion
			if player_health <= 0 and not is_dead:
				is_dead = true  # Set dead state
				sprite.modulate = Color(1, 1, 1, 1)
				
				sprite.play("death")
				death_duration_timer.start()  # Start timer for death animation duration
				return  # Exit to prevent further processing

			if player_health <= -5.0:
				health_depleted.emit()
				joystick.hide()
				sprite.queue_free()
				get_node("../GameOver").game_over()
				print("you died")

func _on_invincible_state_timer_timeout() -> void:
	invincible = false
	sprite.modulate = Color(1, 1, 1, 1)

# Function to handle attack input
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_right") and not is_attacking and not is_dead:
		last_direction = "right"
		attack()
	elif event.is_action_pressed("shoot_left") and not is_attacking and not is_dead:
		last_direction = "left"
		attack()
	elif event.is_action_pressed("shoot_up") and not is_attacking and not is_dead:
		last_direction = "up"
		attack()
	elif event.is_action_pressed("shoot_down") and not is_attacking and not is_dead:
		last_direction = "front"
		attack()

# Attack function
func attack():
	is_attacking = true  # Set attacking state
	velocity = Vector2(0, 0)  # Stop movement while attacking

	# Determine the correct attack animation based on direction
	if last_direction == "front":
		sprite.play("attack_front")
	elif last_direction == "right" or last_direction == "left":
		sprite.play("attack_side")
		# Flip sprite based on direction (left or right)
		sprite.flip_h = (last_direction == "left")
	elif last_direction == "up":
		sprite.play("attack_back")

	# Start attack duration timer to manage attack duration
	attack_duration_timer.start()

func _on_attack_duration_timer_timeout() -> void:
	# After attack animation ends, allow movement again
	is_attacking = false
	if not is_dead:  # Only resume movement if not dead
		velocity = current_velocity  # Resume movement based on joystick hold

# Function to handle death animation end
func _on_death_duration_timeout() -> void:
	health_depleted.emit()
	joystick.hide()
	sprite.queue_free()
	get_node("../GameOver").game_over()
	print("you died")
