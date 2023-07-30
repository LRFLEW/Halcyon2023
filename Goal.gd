extends Area2D

class_name Goal

signal level_complete

@export var window : Window

var originals : Dictionary
var completed := false

@onready var win : Window = window if window else get_window()
@onready var confetti := $"../Confetti"

func _ready():
	for owner_id in get_shape_owners():
		var pos : Vector2 = shape_owner_get_owner(owner_id).global_position
		var size : Vector2 = shape_owner_get_shape(owner_id, 0).size
		originals[owner_id] = Rect2(pos - size / 2.0, size)

func _physics_process(delta):
	for owner_id in get_shape_owners():
		var col : Rect2 = originals[owner_id]
		var wrect := Rect2(Vector2(win.position) - Main.screen_origin, win.size)
		var res := col.intersection(wrect)
		shape_owner_get_shape(owner_id, 0).size = res.size
		shape_owner_get_owner(owner_id).global_position = res.get_center()

func triggered(body : Node2D):
	if !completed:
		completed = true
		confetti.restart()
		level_complete.emit()
