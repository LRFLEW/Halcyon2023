extends Window

@export var track : Node2D
@export var layer := 1

@onready var camera : Camera2D = $Camera2D

func _ready():
	world_2d = get_tree().get_root().world_2d
	canvas_cull_mask = 1 << layer

func _process(delta):
	camera.position = track.position
	position = track.position + Main.screen_origin

func _input(event):
	if event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()
