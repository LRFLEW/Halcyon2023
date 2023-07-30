extends Area2D

var enabled := false
var win_good := true
var win_last : Rect2i

@onready var anim := $Arrow/AnimationPlayer

func _process(delta):
	var win := get_window()
	if win_last and win_good:
		if win.position != win_last.position or win.size != win_last.size:
			anim.play("RESET")
			win_good = false
	else:
		win_last = Rect2i(win.position, win.size)

func on_player_enter(body : Node2D):
	if enabled and win_good:
		anim.play("Hint")

func on_player_exit(body : Node2D):
	anim.play("RESET")

func set_enabled(status : bool):
	enabled = status
