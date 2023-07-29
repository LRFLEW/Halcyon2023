extends Node2D

class_name Main

static var screen_origin : Vector2

@onready var camera := $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var win := get_window()
	screen_origin = win.position
	win.canvas_cull_mask = 1

func _process(delta):
	var newpos : Vector2 = get_window().position
	camera.position = newpos - screen_origin
