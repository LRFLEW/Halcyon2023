extends Area2D

signal button_state(state : bool)

@onready var sprite := $AnimatedSprite2D

func on_body(body : Node2D):
	var press := has_overlapping_bodies()
	sprite.play("Pressed" if press else "Unpressed")
	button_state.emit(press)
