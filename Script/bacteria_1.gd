extends CharacterBody2D

var health = 50
@onready var player: CharacterBody2D = %Player  # Make sure this reference is correct
@onready var bacteria_anim = $AnimatedSprite2D
@onready var on_hit_sound: AudioStreamPlayer2D = $on_hit_sound

var knockback_duration = 0.3  # Duration of the knockback
var knockback_velocity = Vector2.ZERO  # Knockback force
var is_knocked_back = false  # Check if mob is knocked back
var player_in_range = false

func _ready() -> void:
	bacteria_anim.modulate = Color(1.3, 2.5, 1.3, 1)

func _physics_process(delta):
	bacteria_anim.play("idle")

	# Handle knockback
	if is_knocked_back:
		velocity = knockback_velocity
		knockback_duration -= delta
		if knockback_duration <= 0:
			is_knocked_back = false
			knockback_velocity = Vector2.ZERO  # Reset knockback velocity
	else:
		# Regular movement when not knocked back
		if player_in_range:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * 200.0 
			
			var overlapping_player = %stop_range.get_overlapping_bodies()
			if overlapping_player.size() > 0:
				velocity = Vector2.ZERO
		else:
			velocity = Vector2.ZERO
	
	move_and_slide()

func take_damage():
	health -= PlayerSystem.damage
	on_hit_sound.play()
	%ProgressBar.value = health
	CShake.camera_shake()
	
	# Apply knockback when taking damage
	apply_knockback()
	
	if health <= 0:
		on_hit_sound.play()
		ScoreManager.bacteria_score()
		ScoreManager.addWorld1Objective()
		queue_free()
		
		const EXPLOTION = preload("res://Particles/explosion.tscn")
		var explotion = EXPLOTION.instantiate()
		get_parent().add_child(explotion)
		explotion.global_position = global_position
		explotion.scale = Vector2(5, 5)
		
		#const SMOKE_SCENE = preload("res://Scenes/smoke_explotion.tscn")
		#var smoke = SMOKE_SCENE.instantiate()
		#get_parent().add_child(smoke)
		#smoke.global_position = global_position

func apply_knockback():
	# Calculate knockback force based on the direction away from the player
	var knockback_direction = global_position.direction_to(player.global_position).normalized()
	knockback_velocity = -knockback_direction * 300  
	bacteria_anim.modulate = Color(100, 100, 100, 100)
	is_knocked_back = true
	knockback_duration = 0.3  # Reset the knockback duration
	$hit_anim.start()
	
func _on_mob_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = true

func _on_mob_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false
		velocity = Vector2.ZERO


func _on_hit_anim_timeout() -> void:
	bacteria_anim.modulate = Color(1.3, 2.5, 1.3, 1)
