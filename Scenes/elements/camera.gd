extends Camera2D

@export var target : Node2D


func _physics_process(_delta):
	if !target: return
	position = target.position
