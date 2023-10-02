extends Node
class_name scene_controller

@export var init_scene : PackedScene

var current_level : Node
var levels_path := "res://Scenes/levels/level%s/level.tscn"
var current_level_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if init_scene:
		current_level = init_scene.instantiate()
		add_child(current_level)

func next_level():
	current_level_index += 1
	get_tree().queue_delete(current_level)
	var load_level : PackedScene = load(levels_path % current_level_index)
	current_level = load_level.instantiate()
	add_child(current_level)
