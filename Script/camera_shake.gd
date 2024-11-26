extends Node

signal cam_shake()


func camera_shake():
	emit_signal("cam_shake") 
