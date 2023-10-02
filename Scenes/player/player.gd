extends CharacterBody2D
class_name Player

var initial_position : Vector2

func _ready():
	initial_position = global_position

func reset():
	global_position = initial_position

func _on_world_area_area_entered(area):
	reset()
