extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $Main/Panel/Node2D/AnimatedSprite2D
@onready var click: AudioStreamPlayer2D = $click

@onready var main: CanvasLayer = $Main
@onready var options: CanvasLayer = $Options
@onready var scoreboard: CanvasLayer = $scoreboard
@onready var upgrades: CanvasLayer = $Upgrades




func _ready():
	animated_sprite_2d.play("default")
	main.show()
	scoreboard.hide()
	options.hide()

func _on_play_pressed() -> void:
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	



func _on_options_pressed() -> void:
	click.play()
	await click.finished
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	click.play()
	await click.finished
	get_tree().quit()


func _on_score_pressed() -> void:
	click.play()
	await click.finished
	main.hide()
	scoreboard.show()
	pass # Replace with function body.



func _on_return_pressed() -> void:
	click.play()
	await click.finished
	main.show()
	scoreboard.hide()
	


func _on_upgrades_pressed() -> void:
	click.play()
	await click.finished
	upgrades.show()
	main.hide()
