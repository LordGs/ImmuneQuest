extends Sprite2D

@onready var previous: Node2D = $".."

var pressing = false


@export var maxLength = 250
@export var deadzone = 5


func _ready():
	maxLength *= previous.scale.x
func _process(delta: float) -> void:
	if pressing:
		if get_global_mouse_position().distance_to(previous.global_position) <= maxLength: global_position = get_global_mouse_position()
		else:
			var angle = previous.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = previous.global_position.x + cos(angle) * maxLength
			global_position.y = previous.global_position.y + sin(angle) * maxLength
		_calculateVector()
	else:
		global_position = lerp(global_position, previous.global_position, delta * 10)
		previous.posVector = Vector2(0,0)
	print(previous.posVector)
		
func _calculateVector():
	if abs((global_position.x - previous.global_position.x)) >= deadzone:
		previous.posVector.x = (global_position.x - previous.global_position.x)/maxLength
	if abs((global_position.y - previous.global_position.y)) >= deadzone:
		previous.posVector.y = (global_position.y - previous.global_position.y)/maxLength
func _on_button_button_down() -> void:
	pressing = true


func _on_button_button_up() -> void:
	pressing = false
