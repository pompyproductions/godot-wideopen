extends Area2D

var directions = {
	"move_right": Vector2.RIGHT,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT,
	"move_up": Vector2.UP
}
var dir_current = []
var GRID_SIZE: Vector2 # on ready, main scene passes this value to all that need this
onready var node_timer = $Timer
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var node_tween = $Tween
onready var node_raycast = $RayCast2D

signal player_moved(dir)

func _ready():
	pass # Replace with function body.

func _unhandled_key_input(event):
	for dir in directions.keys():
		if event.is_action_pressed(dir):
			if node_timer.is_stopped():
				node_timer.start()
				move(directions[dir])
			if not directions[dir] in dir_current:
				dir_current.append(directions[dir])
		elif event.is_action_released(dir):
			if directions[dir] in dir_current:
				dir_current.erase(directions[dir])
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_Timer_timeout():
	if dir_current == []:
		node_timer.stop()
	else:
		var move_to = dir_current[-1]
		move(move_to)

func move(dir):
	if dir.x < 0:
		$Sprite.flip_h = true
	elif dir.x > 0:
		$Sprite.flip_h = false
	if check_object(dir) == null:
		node_tween.interpolate_property(self, "position",
		position, position + Vector2(dir.x*20, dir.y*11),
		0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		node_tween.start()
		state_machine.travel("walk")
	else:
		dir = Vector2.ZERO
	emit_signal("player_moved", dir)

func check_object(dir):
	node_raycast.cast_to = dir * GRID_SIZE
	node_raycast.force_raycast_update()
	return(node_raycast.get_collider())
