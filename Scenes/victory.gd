extends CanvasLayer

@onready var click: AudioStreamPlayer2D = $"../click"
@onready var gameover: AudioStreamPlayer2D = $"../gameover"
@onready var scores = $Panel/Score_label/score
@onready var score_count: Label = $"../CanvasLayer/Control3/score_count"
@onready var shoot: Control = $"../CanvasLayer/shoot"
@onready var victory_sfx: AudioStreamPlayer2D = $"../Player/victory_sfx"




func _ready() -> void:
	self.hide()



func victory():
	get_tree().paused = true
	
	scores.text = score_count.text
	
	# Update the Global score with the value from the score_count label
	global.score = int(score_count.text)  # Ensure you convert the text to an integer

	# Check and save the high score
	if global.score > global.highscore:
		global.highscore = global.score
		global.save_highscore()  # Save the new high score to file
		print("New high score saved: ", global.highscore)
	
	shoot.hide()
	self.show()


func _on_restart_pressed() -> void:
	click.play()
	await click.finished
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_next_pressed() -> void:
	click.play()
	await click.finished
	get_tree().paused = false
	get_tree().reload_current_scene()
