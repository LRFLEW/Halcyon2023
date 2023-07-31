extends CharacterBody2D

const SPEED := 350.0
const JUMP_VELOCITY := -500.0

@export var hshift := 4.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
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
	if abs(direction) > 0.0:
		sprite.play("Walk")
	else:
		sprite.play("Idle")
	
	var has_col := move_and_slide()
	if has_col:
		for i in get_slide_collision_count():
			var col := get_slide_collision(i)
			if col.get_collider() is RigidBody2D:
				var ncol = col.get_collider().move_and_collide(Vector2(col.get_remainder().x, 0.0))
