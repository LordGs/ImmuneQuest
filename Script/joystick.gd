extends Node2D

var posVector: Vector2

func get_direction() -> Vector2:
	return posVector.normalized()
