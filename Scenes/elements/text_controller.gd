extends Node2D

@onready var message = $message

@export var message_speed := 30
@export var message_list : Array[String] = []
@export var can_action := true
@export_enum("destroy", "reset") var on_finish : String = "destroy"

var index = 0


func action():
	if !can_action: return
	
	index += 1
	
	# Si sobrepasamos el límite
	if index >= message_list.size():
		handle_on_finish()
		return
	
	message.show_text(message_list[index], message_speed)


func handle_on_finish():
	match on_finish:
		"destroy":
			get_tree().queue_delete(self)
		"reset":
			message.show_text("")
			index = 0


func _on_message_area_body_entered(body):
	if message_list.size() <= 0: return
	message.show_text(message_list[index], message_speed)


func _on_message_area_body_exited(body):
	message.show_text("")
	index = 0
