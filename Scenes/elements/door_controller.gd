extends Node2D

@onready var message = $message

@export var message_text := "Enter"
@export var message_speed := 30

func action():
	var controller : scene_controller = get_parent().get_parent()
	controller.next_level()

func _on_trigger_area_body_entered(body):
	message.show_text(message_text, message_speed)


func _on_trigger_area_body_exited(body):
	message.show_text("")
