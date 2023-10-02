extends State

@onready var actionable_area = $"../../ActionableArea"
@onready var animator = $"../../AnimatedSprite2D"


@export var SPEED = 100.0
@export var ACCELERATION : float = 800
@export var JUMP_VELOCITY = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player : CharacterBody2D
var flip := false

func start():
	player = get_parent().get_parent()

func fixed_update(delta):
	var animation_name = "idle"
	
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
	
	if player.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			player.velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("jump") and player.velocity.y < JUMP_VELOCITY / 2:
			player.velocity.y = JUMP_VELOCITY / 2
	
	if Input.is_action_just_pressed("surface"):
		Transition.emit(self, "surface")
	
	if Input.is_action_just_pressed("action"):
		actionable_area.action_all()
	
	var x_direction = Input.get_axis("ui_left", "ui_right")
	player.velocity.x = move_toward(player.velocity.x, SPEED * x_direction, ACCELERATION * delta)
	
	
	if player.velocity.x != 0:
		animator.flip_h = player.velocity.x < 0
		animation_name = "move"
	
	if player.velocity.y < 0:
		animation_name = "jump"
	if player.velocity.y > 0:
		animation_name = "fall"
	
	animator.play(animation_name)
	
	player.move_and_slide()
