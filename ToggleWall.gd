extends CropCollision

@export var default_state := false
@export var disable_opacity := 0.3

@onready var tilemap : TileMap = $TileMap

func _set_state(state : bool):
	tilemap.modulate.a = 1.0 if state else disable_opacity
	process_mode = Node.PROCESS_MODE_INHERIT if state else Node.PROCESS_MODE_DISABLED

func update_pressed(pressed : bool):
	_set_state(pressed != default_state)

func _ready():
	super()
	_set_state(default_state)
