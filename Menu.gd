extends Node2D

class_name Menu

static var game_display := -1
static var game_timer := 0.0

const screen_size := Vector2i(1280, 720)

@export_file("*.tscn") var first_level : String

var title : String = ProjectSettings.get_setting("application/config/name")

@onready var overfx : AudioStreamPlayer = $OverFX
@onready var clickfx : AudioStreamPlayer = $ClickFX
@onready var music_bus := AudioServer.get_bus_index("Music")
@onready var sfx_bus := AudioServer.get_bus_index("SFX")

func _ready():
	var win := get_window()
	var screen := Rect2i(DisplayServer.screen_get_position(), DisplayServer.screen_get_size())
	var root := screen.get_center() - (screen_size / 2)
	
	win.position = root
	win.size = screen_size
	win.unresizable = true
	win.canvas_cull_mask = 1
	win.title = title
	MusicPlayer.switch_track(MusicPlayer.Tracks.Menu)
	
	$MusicSlider.value = AudioServer.get_bus_volume_db(music_bus)
	$SFXSlider.value = AudioServer.get_bus_volume_db(sfx_bus)

func _input(event):
	if event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()

func on_mouse_over():
	overfx.play()

func change_music_volume(value : float):
	AudioServer.set_bus_volume_db(music_bus, value)
	AudioServer.set_bus_mute(music_bus, value <= -30.0)

func change_sfx_volume(value : float):
	AudioServer.set_bus_volume_db(sfx_bus, value)
	AudioServer.set_bus_mute(sfx_bus, value <= -30.0)

func do_play():
	game_display = DisplayServer.window_get_current_screen(get_window().get_window_id())
	game_timer = 0.0
	get_tree().change_scene_to_file(first_level)

func play():
	if clickfx.finished.get_connections().is_empty():
		clickfx.finished.connect(do_play)
		clickfx.play()

func do_quit():
	get_tree().quit()

func quit():
	if clickfx.finished.get_connections().is_empty():
		clickfx.finished.connect(do_quit)
		clickfx.play()
