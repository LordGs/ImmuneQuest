# Global.gd
extends Node

var score: int = 0
var highscore: int = 0

# Function to save the high score to a file as plain text
func save_highscore():
	var file = FileAccess.open("user://highscore_data.txt", FileAccess.WRITE)
	file.store_line(str(highscore))  # Save the high score as a string
	file.close()
	print("High score saved to file: ", highscore)

# Function to load the high score from a file as plain text
func load_highscore():
	if FileAccess.file_exists("user://highscore_data.txt"):
		var file = FileAccess.open("user://highscore_data.txt", FileAccess.READ)
		highscore = int(file.get_line().strip_edges())  # Read and convert it to an integer
		file.close()
		print("High score loaded from file: ", highscore)
	else:
		print("No high score file found, starting with high score 0.")
