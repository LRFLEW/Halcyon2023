extends Node2D

const screen_size := Vector2i(1280, 720)
const screen_pad := 200.0

@export_file("*.tscn") var menu_scene : String

var title : String = ProjectSettings.get_setting("application/config/name")

@onready var overfx : AudioStreamPlayer = $OverFX
@onready var music_bus := AudioServer.get_bus_index("Music")
@onready var sfx_bus := AudioServer.get_bus_index("SFX")
@onready var winbox : StaticBody2D = $WindowBox
@onready var scrnbox : StaticBody2D = $ScreenBox

func _ready():
	var win := get_window()
	var screen := Rect2i(
		DisplayServer.screen_get_position(Menu.game_display),
		DisplayServer.screen_get_size(Menu.game_display))
	var root := screen.get_center() - Vector2i(640, 360)
	
	Main.screen_origin = root
	win.position = root
	win.size = screen_size
	win.unresizable = true
	win.canvas_cull_mask = 1
	win.title = title
	MusicPlayer.switch_track(MusicPlayer.Tracks.Victory)
	
	$MusicSlider.value = AudioServer.get_bus_volume_db(music_bus)
	$SFXSlider.value = AudioServer.get_bus_volume_db(sfx_bus)
	
	var boxid := winbox.get_shape_owners()[0]
	var boxshape := winbox.shape_owner_get_shape(boxid, 0)
	winbox.shape_owner_remove_shape(boxid, 0)
	winbox.shape_owner_add_shape(boxid, boxshape.duplicate(true))
	
	var visscreen : Rect2 = DisplayServer.screen_get_usable_rect(Menu.game_display)
	var viscenter := visscreen.get_center()
	var scrnids := scrnbox.get_shape_owners()
	for i in 4:
		var obj := scrnbox.shape_owner_get_owner(scrnids[i])
		var shape := scrnbox.shape_owner_get_shape(scrnids[i], 0)
		match i:
			0:
				shape.size = Vector2(visscreen.size.x + screen_pad * 2.0, screen_pad)
				obj.position = Vector2(viscenter.x, visscreen.position.y - screen_pad / 2.0) - Vector2(root)
			1:
				shape.size = Vector2(visscreen.size.x + screen_pad * 2.0, screen_pad)
				obj.position = Vector2(viscenter.x, visscreen.end.y + screen_pad / 2.0) - Vector2(root)
			2:
				shape.size = Vector2(screen_pad, visscreen.size.y)
				obj.position = Vector2(visscreen.position.x - screen_pad / 2.0, viscenter.y) - Vector2(root)
			3:
				shape.size = Vector2(screen_pad, visscreen.size.y)
				obj.position = Vector2(visscreen.end.x + screen_pad / 2.0, viscenter.y) - Vector2(root)
	
	$Time.text = "in %.02f seconds" % Menu.game_timer

func _process(_delta):
	var win := get_window()
	if win.mode != Window.MODE_WINDOWED:
		win.mode = Window.MODE_WINDOWED
	
	var boxid := winbox.get_shape_owners()[0]
	var box := winbox.shape_owner_get_owner(boxid)
	var boxshape := winbox.shape_owner_get_shape(boxid, 0)
	boxshape.size = win.size
	box.position = Vector2(win.position) - Main.screen_origin

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

func menu():
	get_tree().change_scene_to_file(menu_scene)
