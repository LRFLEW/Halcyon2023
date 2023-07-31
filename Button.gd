extends Area2D

signal button_state(state : bool)

var prev_state := false

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var press_sound : AudioStreamPlayer = $PressSound
@onready var depress_sound : AudioStreamPlayer = $DepressSound

func on_body(body : Node2D):
	var press := has_overlapping_bodies()
	if press != prev_state:
		prev_state = press
		sprite.play("Pressed" if press else "Unpressed")
		if press: press_sound.play()
		else: depress_sound.play()
		button_state.emit(press)
