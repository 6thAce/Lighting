extends CharacterBody2D


const SPEED = 350.0
const JUMP_VELOCITY = -500.0

# --- NEW CONSTANTS FOR SMOOTHER JUMPING ---
const FALL_MULTIPLIER = 2.0  # Make the character fall faster than they rise.
const JUMP_CANCEL_MULTIPLIER = 0.5 # Make the character stop rising when the jump key is released.

const ACCELERATION = 1200.0
const FRICTION = 1500.0


func _physics_process(delta: float) -> void:
	# Add the gravity to the vertical velocity.
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

		# ==========================================================
		# THE SMOOTHER JUMPING LOGIC HAS BEEN ADDED HERE
		# ==========================================================
		# Make the jump variable (for short hops).
		if velocity.y < 0 and not Input.is_action_pressed("ui_accept"):
			velocity.y += get_gravity().y * (JUMP_CANCEL_MULTIPLIER) * delta

		# Apply a fall multiplier to make the fall feel snappier.
		if velocity.y > 0:
			velocity.y += get_gravity().y * (FALL_MULTIPLIER - 1) * delta

	# Handle jump input.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the horizontal input direction.
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		
		if direction > 0:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()
