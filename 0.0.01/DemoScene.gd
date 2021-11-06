extends Node

const GRID_SIZE := Vector2(20, 11)

onready var debug_label_1 = $CanvasLayer/DebugLabel1
onready var debug_label_2 = $CanvasLayer/DebugLabel2

onready var character = $YSort/Character
onready var cam = $Camera2D
onready var arrow_hud = $ArrowHUD

func _ready():
	character.connect("player_moved", self, "on_player_move")
	for node in get_tree().get_nodes_in_group("receive_constants"):
		node.GRID_SIZE = GRID_SIZE
	arrow_hud.target = character.position

func _process(_delta):
	debug_label_1.text = str(character.dir_current)
	debug_label_2.text = "timer_on: " + str(!character.get_node("Timer").is_stopped())
	arrow_hud.buttons_pressed = character.dir_current

func on_player_move(dir):
	print("player moved to " + str(dir))
	cam.target += dir * GRID_SIZE
	arrow_hud.target += dir * GRID_SIZE
	print(cam.target)
