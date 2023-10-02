extends Node

@export var initial_state : State

var state_list : Dictionary
var current_state : State


func _ready():
	
	if initial_state:
		current_state = initial_state
		current_state.start()
	
	for child in get_children():
		if !child is State: continue
		state_list[child.name] = child
		child.Transition.connect(on_change_state)

func _process(delta):
	if !current_state: return
	current_state.update(delta)

func _physics_process(delta):
	if !current_state: return
	current_state.fixed_update(delta)


func on_change_state(state : State = null, new_state_name : String = ""):
	
	var new_state = state_list[new_state_name]
	
	if !new_state: return
	if current_state: current_state.finish()
	
	current_state = new_state
	current_state.start()
