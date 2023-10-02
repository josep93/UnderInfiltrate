extends Node2D

@export var sounds : Array[AudioStream]

@onready var animator = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_degrees = [0, 90, 180, 270][randi_range(0, 3)]
	modulate.a = randf_range(0.4, 1)
	animator.play("default")
	audio.stream = sounds[randi_range(0, 1)]
	audio.pitch_scale = randf_range(0.5, 1.2)
	audio.play()


func _on_animated_sprite_2d_animation_finished():
	get_tree().queue_delete(self)
