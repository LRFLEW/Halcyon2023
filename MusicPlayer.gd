extends AudioStreamPlayer

@export var muted := false

enum Tracks { Menu, Stage, Victory }

var tracks : Array[AudioStream] = [
	load("res://Juhani Junkala [Chiptune Adventures] 4. Stage Select.ogg"),
	load("res://Juhani Junkala [Chiptune Adventures] 1. Stage 1.ogg"),
	load("res://Juhani Junkala [Chiptune Adventures] 2. Stage 2.ogg"),
]
var current_track := Tracks.Menu

func _ready():
	volume_db = -3.0
	bus = "Music"
	stream = tracks[current_track]
	play()

func switch_track(track : Tracks):
	if track != current_track:
		current_track = track
		stream = tracks[track]
		play()
