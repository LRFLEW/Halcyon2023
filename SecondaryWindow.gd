extends Window

@export var start_pos := Vector2i(0, 0)
@export var start_size := Vector2i(1280, 720)

@onready var camera := $Camera2D

func _ready():
	close_requested.connect(handle_close)
	var root := get_tree().get_root()
	world_2d = root.world_2d
	position = root.position + start_pos
	size = start_size
	canvas_cull_mask = 1

func _process(delta):
	camera.position = Vector2(position) - Main.screen_origin

func handle_close():
	get_tree().quit()
