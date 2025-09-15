extends CharacterBody2D


# --- Character Properties ---
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


# --- Physics-based processing for movement ---
func _physics_process(delta: float) -> void:
	# Add the gravity to the vertical velocity.
	if not is_on_floor():
		velocity.y += get_gravity().y * delta # CORRECTED LINE HERE

	# Handle jump input.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the horizontal input direction.
	var direction := Input.get_axis("ui_left", "ui_right")

	# If there is a horizontal input:
	if direction:
		# Set the horizontal velocity directly to the target speed.
		velocity.x = direction * SPEED
		
		# Flip the sprite based on the movement direction.
		# The '$' is a shorthand to get a child node by its name.
		if direction > 0:
			$Sprite2D.flip_h = false  # Face right
		else:
			$Sprite2D.flip_h = true   # Face left
	else:
		# If no input, slow the character to a stop.
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Apply the velocity and handle collisions.
	move_and_slide()
