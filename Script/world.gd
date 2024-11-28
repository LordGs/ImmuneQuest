extends Node2D

#control
@onready var player = %Player
@onready var ui_health = $CanvasLayer/Control/ProgressBar
#control2
var timer_variable: int = 0
@onready var timer_label: Label = $CanvasLayer/Control2/time
@onready var timer_node: Timer = $CanvasLayer/Control2/Timer
#control3
@onready var score_count: Label = $CanvasLayer/Control3/score_count
@onready var objective: Label = $CanvasLayer/Control/Objective
@onready var victory: CanvasLayer = $Victory
@onready var victory_timer: Timer = $Victory/victory_timer
@onready var victory_sfx: AudioStreamPlayer2D = $Player/victory_sfx

@onready var shoot: Control = $CanvasLayer/shoot


var scores = 0
var countdown = "start_counting"

var killCount = 0
var KillObjective = 15
func _ready() -> void:
	#hide the old control
	shoot.hide()
	
	objective.text = "Objective: Kill the\nscattered Bacterias " + str(killCount )+ "/" + str(KillObjective)
	ScoreManager.connect("add_bacteria_score", bacteriaScore)
	ScoreManager.connect("add_mushroom_score", mushroomScore)
	ScoreManager.connect("add_worldOneObjective", addObjective)
	
	# Unpause the game when the world scene is loaded
	get_tree().paused = false
	timer_node.start()
	
func format_time(seconds: int) -> String:
	var minutes = seconds / 60
	var remaining_seconds = seconds % 60
	return "%02d:%02d" % [minutes, remaining_seconds]
	
func _physics_process(delta: float) -> void:
	score_count.text = str(scores)
	ui_health.value = player.player_health
	
	

func _on_timer_timeout() -> void:
	timer_variable += 1  # Increment the timer variable
	timer_label.text = format_time(timer_variable)  # Update the label with the formatted time
	print("Timer tick: ", timer_variable)
	timer_node.start()

#Scoring
func bacteriaScore() -> void:
	scores += 240
func mushroomScore() -> void:
	scores += 500
	
#objective
func addObjective() -> void:
	killCount += 1
	#Update the Objective
	objective.text = "Objective: Kill the\nscattered Bacterias " + str(killCount )+ "/" + str(KillObjective)
	
	
	if killCount == KillObjective:
		victory_timer.start()
		
	
	

@onready var pause_state: CanvasLayer = $PauseState

func _on_button_pressed() -> void:
	pause_state.paused_state()



func _on_victory_timer_timeout() -> void:
	victory.victory()
	victory_sfx.play()
	
