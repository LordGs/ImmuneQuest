extends CanvasLayer
@onready var click: AudioStreamPlayer2D = $"../click"

func _ready() -> void:
	self.hide()
	
	
	
func paused_state():
	get_tree().paused = true
	self.show()


func _on_resume_pressed() -> void:
	click.play()
	await click.finished
	get_tree().paused = false
	self.hide()


func _on_restart_pressed() -> void:
	click.play()
	await click.finished
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
