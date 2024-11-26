extends Node

signal add_bacteria_score()  
signal add_mushroom_score()
signal add_worldOneObjective()

var scores: int = 0  


func _ready() -> void:
	scores = 0 #does this reset the score whenever it loads?
	
func bacteria_score():
	emit_signal("add_bacteria_score") 
	
func mushroom_score():
	emit_signal("add_mushroom_score") 

func addWorld1Objective():
	emit_signal("add_worldOneObjective")
