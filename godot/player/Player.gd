extends KinematicBody2D

const MAX_SPEED = 500
const ACCELERATION = 2000
var motion = Vector2.ZERO

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:# ZERO = (0,0) = basically der origin (zB Ruhepos vom Stick)
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
