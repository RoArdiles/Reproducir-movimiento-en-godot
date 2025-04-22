extends CharacterBody2D

const ACCELERATION_STEP = 100.0
const DECELERATION_STEP = 150.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var jump_count = 0
var current_speed = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")
		if is_on_floor():
			jump_count = 0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count = 1
		elif jump_count < 2:
			velocity.y = JUMP_VELOCITY
			jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction !=0:
		current_speed = min(current_speed + ACCELERATION_STEP * delta, SPEED)
		velocity.x = direction * current_speed
		if is_on_floor():
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = direction < 0
	else:
		current_speed = max(current_speed - DECELERATION_STEP * delta, 0)
		velocity.x = move_toward(velocity.x, 0, DECELERATION_STEP * delta)
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
		
	move_and_slide()
	$Label.text = "Velocidad: %.2f" % velocity.length()
	
