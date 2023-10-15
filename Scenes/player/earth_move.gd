extends Node2D
@onready var rock_sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_degrees = [0, 90, 180, 270][randi_range(0, 3)]
	modulate.a = randf_range(0.4, 1)
	
	rock_sprite.frame = randi_range(0, 1)
	rock_sprite.position = Vector2(randf_range(-2, -3), randf_range(-8, 8))
	rock_sprite.rotation_degrees = randf_range(-180, 180)


func _on_timer_timeout():
	get_tree().queue_delete(self)
