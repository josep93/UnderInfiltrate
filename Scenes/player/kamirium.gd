extends ProgressBar

var player : Player
var units_per_second := 35
var operation := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	value = 100
	player = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value += (delta * units_per_second) * operation
	if value <= 0:
		value = 100
		player.reset()

func set_operation(new_operation : int):
	if new_operation != -1 and new_operation != 1: return
	operation = new_operation
