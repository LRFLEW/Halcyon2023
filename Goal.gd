extends Area2D

signal level_complete

@export var window : Window

var originals : Dictionary

@onready var win : Window = window if window else get_window()

func _ready():
	for owner_id in get_shape_owners():
		var pos : Vector2 = shape_owner_get_owner(owner_id).global_position
		var shape := shape_owner_get_shape(owner_id, 0)
		shape_owner_remove_shape(owner_id, 0)
		shape_owner_add_shape(owner_id, shape.duplicate(true))
		originals[owner_id] = Rect2(pos - shape.size / 2.0, shape.size)

func _physics_process(delta):
	for owner_id in get_shape_owners():
		var col : Rect2 = originals[owner_id]
		var wrect := Rect2(Vector2(win.position) - Main.screen_origin, win.size)
		var res := col.intersection(wrect)
		shape_owner_get_shape(owner_id, 0).size = res.size
		shape_owner_get_owner(owner_id).global_position = res.get_center()

func triggered(body : Node2D):
	level_complete.emit()
