extends Window

@export var start_pos := Vector2i(0, 0)
#@export var start_size := Vector2i(1280, 720)

@onready var camera := $Camera2D

func _ready():
	var screen := Rect2i(DisplayServer.screen_get_position(), DisplayServer.screen_get_size())
	var root := screen.get_center() - Vector2i(1280 / 2, 720 / 2)
	print(root)
	
	visible = true
	close_requested.connect(handle_close)
	world_2d = get_tree().get_root().world_2d
	position = start_pos + root
	canvas_cull_mask = 1

func _process(delta):
	if mode != Window.MODE_WINDOWED:
		mode = Window.MODE_WINDOWED
	camera.position = Vector2(position) - Main.screen_origin

func handle_close():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()
