extends CharacterBody2D

class_name Player

const SPEED := 350.0
const JUMP_VELOCITY := -550.0
const WORLD_END := 800.0
const END_DECEL := 60.0

@export var is_victory := false
@export var respawn_timer := 0.6
@export var hshift := 4.0
@export var footstep_time := 0.33

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var timer := 0.0
var ft_timer := footstep_time
var controllable := true

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var footsteps : AudioStreamPlayer = $Footsteps

func _physics_process(delta):
	if controllable and !is_victory and position.y > WORLD_END:
		timer += delta
		if timer >= respawn_timer:
			get_tree().reload_current_scene()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if controllable:
		# Handle Jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("Left", "Right")
		velocity.x = direction * SPEED
		
		if direction < 0.0:
			sprite.flip_h = true
			sprite.position.x = -hshift
		elif direction > 0.0:
			sprite.flip_h = false
			sprite.position.x = 0.0
		
		ft_timer += delta
		if is_on_floor():
			if abs(direction) > 0.0:
				if sprite.animation != "Walk":
					sprite.play("Walk")
				if ft_timer >= footstep_time and is_on_floor():
					ft_timer = 0.0
					footsteps.play()
			else:
				if is_victory and Input.is_action_just_pressed("Dance"):
					if sprite.animation != "Victory":
						sprite.play("Victory")
					else:
						sprite.play("Idle")
				elif sprite.animation != "JumpLand" and sprite.animation != "Idle" \
						and sprite.animation != "Victory":
					if sprite.animation.begins_with("Jump"):
						sprite.play("JumpLand")
					else:
						sprite.play("Idle")
		else:
			if velocity.y < 0.0:
				if sprite.animation != "JumpRise":
					sprite.play("JumpRise")
			else:
				if sprite.animation != "JumpTransition" and sprite.animation != "JumpFall":
					sprite.play("JumpTransition")
	else:
		if velocity.x > 0.0:
			velocity.x = max(velocity.x - END_DECEL, 0.0)
		elif velocity.x < 0.0:
			velocity.x = min(velocity.x + END_DECEL, 0.0)
	
	var has_col := move_and_slide()
	if has_col:
		for i in get_slide_collision_count():
			var col := get_slide_collision(i)
			if col.get_collider() is RigidBody2D:
				col.get_collider().move_and_collide(Vector2(col.get_remainder().x, 0.0))

func on_victory():
	controllable = false
	sprite.play("Victory")

func animation_next():
	match sprite.animation:
		"JumpTransition":
			sprite.play("JumpFall")
		"JumpLand":
			sprite.play("Idle")
