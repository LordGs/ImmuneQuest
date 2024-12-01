extends TouchScreenButton



@onready var cd: Timer = $cd



func _process(delta: float) -> void:
	if Input.is_action_pressed("dash"):
		cd.start()
		self.hide()


func _on_cd_timeout() -> void:
	self.show()
