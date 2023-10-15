extends State
@onready var coyote_time : Timer = $coyote_time
@onready var earth_generator : Timer = $earth_generator
@onready var kmr = $"../../CanvasLayer/kmr"
@onready var animator = $"../../AnimatedSprite2D"
@onready var audio = $AudioStreamPlayer
@onready var audio_jump_earth = $AudioJumpEarth
@onready var sound_effect_timer = $sound_effect_timer
@onready var particles = $"../../GPUParticles2D"


@export var sounds : Array[AudioStream]
@export var SPEED := 100.0
@export var JUMP_VELOCITY := -100.0

var earth = preload("res://Scenes/player/earth_move.tscn")
var original_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 0
var player : CharacterBody2D
var level : Node2D
var is_undeground := false
var is_grounded := false
var can_jump := true

func start():
	
	player = get_parent().get_parent()
	player.set_collision_mask_value(2, false)
	animator.set_modulate('ffffff3b')
	gravity = original_gravity
	
	level = player.get_parent()


func fixed_update(delta):
	var animation_name = "idle"
	if player.is_on_floor():
		JUMP_VELOCITY = -150.0
	else:
		JUMP_VELOCITY = -95.0
	
	if is_undeground:
		player.velocity.y += (SPEED * delta) * 2
	else:
		player.velocity.y += gravity * delta
	player.velocity.y = clamp(player.velocity.y, -250, JUMP_VELOCITY*-1)

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and can_jump:
		player.velocity.y = JUMP_VELOCITY
		coyote_time.start()
		can_jump = false
		if !player.is_on_floor():
			particles.emitting = true
			kmr.reduce_amount(20)
			audio_jump_earth.play()
	
	if !Input.is_action_pressed("surface") and !is_undeground:
		Transition.emit(self, "run")
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		player.velocity.x = direction * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
	
	
	if player.velocity.x != 0 or !player.is_on_floor():
		if is_undeground and earth_generator.is_stopped():
			earth_generator.start(0)
	else:
		earth_generator.stop()
	
	if player.velocity.x != 0:
		animator.flip_h = player.velocity.x < 0
		animation_name = "move"
	else:
		animation_name = "idle"
		
	if player.velocity.y < 0:
		animation_name = "jump"
	if player.velocity.y > 0 and !player.is_on_floor():
		animation_name = "fall"
	
	animator.play(animation_name)
	
	player.move_and_slide()


func finish():
	player.set_collision_mask_value(2, true)
	animator.set_modulate('ffffff')
	coyote_time.stop()
	earth_generator.stop()
	sound_effect_timer.stop()
	is_grounded = false
	is_undeground = false
	can_jump = true



func _on_area_2d_body_entered(body):
	is_undeground = true
	earth_generator.start()
	sound_effect_timer.start()
	_on_sound_effect_timer_timeout()
	kmr.set_operation(-1)
	gravity = original_gravity / 3
	player.velocity.y = clamp(player.velocity.y, JUMP_VELOCITY, JUMP_VELOCITY*-1)

func _on_area_2d_body_exited(body):
	is_undeground = false
	earth_generator.stop()
	sound_effect_timer.stop()
	kmr.set_operation(1)
	gravity = original_gravity
	if audio.playing:
		audio.stop()

func _on_coyote_time_timeout():
	can_jump = true

func _on_earth_generator_timeout():
	var object : Node2D = earth.instantiate()
	object.global_position = player.global_position
	level.add_child(object)
	

func _on_sound_effect_timer_timeout():
	audio.stream = sounds[randi_range(0, 1)]
	audio.pitch_scale = randf_range(0.5, 1.2)
	audio.play()
