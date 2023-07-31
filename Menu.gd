extends Node2D

class_name Menu

static var game_display := -1
static var game_timer := 0.0

const screen_size := Vector2i(1280, 720)

@export_file("*.tscn") var first_level : String

var title : String = ProjectSettings.get_setting("application/config/name")

@onready var overfx : AudioStreamPlayer = $OverFX

func _ready():
	var win := get_window()
	var screen := Rect2i(DisplayServer.screen_get_position(), DisplayServer.screen_get_size())
	var root := screen.get_center() - (screen_size / 2)
	
	win.position = root
	win.size = screen_size
	win.unresizable = true
	win.canvas_cull_mask = 1
	win.title = title

func _input(event):
	if event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()

func on_mouse_over():
	overfx.play()

func play():
	game_display = DisplayServer.window_get_current_screen(get_window().get_window_id())
	game_timer = 0.0
	get_tree().change_scene_to_file(first_level)

func quit():
	get_tree().quit()
