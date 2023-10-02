extends Label

@onready var audio = $AudioStreamPlayer

var speed := 20.0

var index := 0
var delta_counter = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta_counter += delta * speed
	if delta_counter >= 1 and visible_characters < get_total_character_count():
		visible_characters += 1
		delta_counter = 0
		if visible_characters % 2 == 1: 
			audio.pitch_scale = randf_range(1.0, 1.5)
			audio.play()
	
	if visible_ratio >= 1:
		return

func show_text(new_text : String, new_speed : float = 20):
	text = new_text
	visible_ratio = 0
	delta_counter = 0
	speed = new_speed
