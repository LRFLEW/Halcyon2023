extends Node2D

class_name Main

static var screen_origin : Vector2

@export var start_pos := Vector2i(0, 0)
@export var start_size := Vector2i(1280, 720)
@export var unresizable := false
@export_file var next_level : String
@export var completion_timer := 1.5

var completed := false
var timer := 0.0

@onready var camera : Camera2D = $Camera2D
@onready var player : Player = $Player
@onready var confetti : CPUParticles2D = $Confetti
@onready var winsound : AudioStreamPlayer = $WinSound

# Called when the node enters the scene tree for the first time.
func _ready():
	var win := get_window()
	var screen := Rect2i(
		DisplayServer.screen_get_position(Menu.game_display),
		DisplayServer.screen_get_size(Menu.game_display))
	var root := screen.get_center() - Vector2i(640, 360)
	
	screen_origin = root
	win.position = root + start_pos
	win.size = start_size
	win.unresizable = unresizable
	win.canvas_cull_mask = 1
	win.title = ""

func _process(_delta):
	if get_window().mode != Window.MODE_WINDOWED:
		get_window().mode = Window.MODE_WINDOWED
	var newpos : Vector2 = get_window().position
	camera.position = newpos - screen_origin

func _physics_process(delta):
	Menu.game_timer += delta
	if completed:
		timer += delta
		if timer >= completion_timer:
			get_tree().change_scene_to_file(next_level)

func _input(event):
	if event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()

func level_complete():
	if !completed:
		completed = true
		player.on_victory()
		confetti.restart()
		winsound.play()
