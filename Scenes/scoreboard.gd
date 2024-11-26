extends CanvasLayer
@onready var level1: Label = $Panel/Level1/label3

func _ready() -> void:
	global.load_highscore()  # Load the high score from file
	var highscore = global.highscore  # Retrieve the high score
	print("High score loaded: ", highscore)
	level1.text = str(highscore)


func _on_reset_scores_pressed() -> void:
	# Reset the high score in the global variable
	$"../click".play()
	global.highscore = 0
	
	# Optionally, reset the high score in the saved file
	var file = FileAccess.open("user://highscore_data.txt", FileAccess.WRITE)
	file.store_line(str(global.highscore))  # Save the new high score as 0
	file.close()
	
	# Update the UI label to reflect the new high score
	level1.text = str(global.highscore)

	print("High score has been reset to 0.")
