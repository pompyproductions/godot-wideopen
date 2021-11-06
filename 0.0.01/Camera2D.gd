extends Camera2D

const CAM_SPEED = 2
var target: Vector2

func _ready():
	target = position

func _process(delta):
	var cam_delta = target - position
	position = position.move_toward(target, delta * CAM_SPEED * cam_delta.length())
