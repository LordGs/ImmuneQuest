extends Camera2D

@export var randomStrength: float = 20.0
@export var shakeFade: float = 15.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func _ready() -> void:
	CShake.connect("cam_shake", cameraShake)
func _apply_shake():
	shake_strength = randomStrength
	
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		offset = randomOffset()
		
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength), rng.randf_range(-shake_strength,shake_strength))
	
	
func cameraShake():
	_apply_shake()
	
