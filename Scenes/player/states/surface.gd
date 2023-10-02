extends State
@onready var coyote_time : Timer = $coyote_time
@onready var earth_generator : Timer = $earth_generator
@onready var kamirium = $"../../CanvasLayer/kamirium"
@onready var animator = $"../../AnimatedSprite2D"


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -200.0

var earth = preload("res://Scenes/player/earth_move.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player : CharacterBody2D
var level : Node2D
var is_undeground = false
var is_grounded = false
var can_jump = true

func start():
	player = get_parent().get_parent()
	player.set_collision_mask_value(2, false)
	player.set_modulate('ffffff3b')
	
	level = player.get_parent()
	
	coyote_time.start(0)


func fixed_update(delta):
	
	if player.is_on_floor():
		can_jump = true
	
	if is_undeground:
		player.velocity.y += (SPEED * delta) * 4
	else:
		player.velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (player.is_on_floor() or can_jump):
		player.velocity.y = JUMP_VELOCITY
		can_jump = false
	
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
		animator.play("move")
	else:
		animator.play("idle")
		
	
	player.move_and_slide()


func finish():
	player.set_collision_mask_value(2, true)
	player.set_modulate('ffffff')
	coyote_time.stop()
	is_grounded = false
	is_undeground = false
	can_jump = true



func _on_area_2d_body_entered(body):
	is_undeground = true
	earth_generator.start()
	kamirium.set_operation(-1)

func _on_area_2d_body_exited(body):
	is_undeground = false
	earth_generator.stop()
	kamirium.set_operation(1)

func _on_coyote_time_timeout():
	can_jump = false

func _on_earth_generator_timeout():
	var object : Node2D = earth.instantiate()
	object.global_position = player.global_position
	level.add_child(object)
