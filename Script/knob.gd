extends Sprite2D

@onready var joystick: Node2D = get_parent()  # Access the joystick parent node
var pressing = false

@export var maxLength = 250
@export var deadzone = 5

func _ready():
	maxLength *= joystick.scale.x  # Scale according to the parent

func _process(delta: float) -> void:
	if pressing:
		if get_global_mouse_position().distance_to(joystick.global_position) <= maxLength:
			global_position = get_global_mouse_position()
		else:
			var angle = joystick.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = joystick.global_position.x + cos(angle) * maxLength
			global_position.y = joystick.global_position.y + sin(angle) * maxLength
		
		# Update the joystick's posVector with the knob's movement
		_calculateVector()
	else:
		global_position = lerp(global_position, joystick.global_position, delta * 10)
		joystick.posVector = Vector2(0, 0)  # Reset posVector when the knob is not being pressed

func _calculateVector():
	if abs(global_position.x - joystick.global_position.x) >= deadzone:
		joystick.posVector.x = (global_position.x - joystick.global_position.x) / maxLength
	if abs(global_position.y - joystick.global_position.y) >= deadzone:
		joystick.posVector.y = (global_position.y - joystick.global_position.y) / maxLength

func _on_button_button_down() -> void:
	pressing = true

func _on_button_button_up() -> void:
	pressing = false
