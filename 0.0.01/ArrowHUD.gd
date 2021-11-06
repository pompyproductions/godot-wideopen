extends Node2D

var target
const SPEED = 6.5
var buttons_pressed: Array setget update_buttons
onready var children = [$D, $S, $A, $W]
const DIRS = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var pos_delta = target - position
	position = position.move_toward(target, delta * SPEED * pos_delta.length())

func update_buttons(arr):
	if !arr.empty():
		var new_arr = arr.duplicate()
		for i in range(4):
			if new_arr.has(DIRS[i]):
				children[i].frame = 2
			else:
				children[i].frame = 0
		var green_dir = new_arr.pop_back()
		if green_dir.x == 1:
			children[0].frame = 1
		elif green_dir.x == -1:
			children[2].frame = 1
		elif green_dir.y == 1:
			children[1].frame = 1
		else:
			children[3].frame = 1
		
	else:
		for a in children:
			a.frame = 0
	
