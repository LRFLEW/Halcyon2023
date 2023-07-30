extends Node2D

class_name Main

static var screen_origin : Vector2

@export var start_pos := Vector2i(0, 0)
@export var start_size := Vector2i(1280, 720)

@onready var camera := $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var win := get_window()
	var screen := Rect2i(DisplayServer.screen_get_position(), DisplayServer.screen_get_size())
	var root := screen.get_center() - Vector2i(1280 / 2, 720 / 2)
	
	screen_origin = root
	win.position = root + start_pos
	win.size = start_size
	win.canvas_cull_mask = 1

func _process(delta):
	if get_window().mode != Window.MODE_WINDOWED:
		get_window().mode = Window.MODE_WINDOWED
	var newpos : Vector2 = get_window().position
	camera.position = newpos - screen_origin
