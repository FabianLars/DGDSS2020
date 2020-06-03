extends KinematicBody2D

onready var anim = get_node("AnimationPlayer")
const MAX_SPEED = 500 # evtl var statt const, siehe bullet_speed
const ACCELERATION = 2000
var motion = Vector2.ZERO
export var bullet_speed = 1000 # var damit items das buffen können
export var fire_rate = 0.40 # var damit items das buffen können

var bullet = preload("res://player/Bullet.tscn")
var can_fire = true

func _process(_delta):
	if Input.is_action_pressed("shoot_left") and can_fire:
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = 180
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, -motion.y/1.8).rotated(deg2rad(180)))
		get_tree().get_root().add_child(bullet_instance)
		get_node("Sprite").set_flip_h(true)
		can_fire = true
	if Input.is_action_pressed("shoot_right") and can_fire:
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = 0
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, motion.y/1.8).rotated(deg2rad(0)))
		get_tree().get_root().add_child(bullet_instance)
		get_node("Sprite").set_flip_h(false)
		can_fire = true
	if Input.is_action_pressed("shoot_up") and can_fire:
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = -90
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, motion.x/1.8).rotated(deg2rad(-90)))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = true
	if Input.is_action_pressed("shoot_down") and can_fire:
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = 90
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, -motion.x/1.8).rotated(deg2rad(90)))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = true

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:# ZERO = (0,0) = basically der origin (zB Ruhepos vom Stick)
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)
	animation_loop()

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	axis.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return axis.normalized()

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

func animation_loop():

	if Input.is_action_just_pressed("shoot_up") and can_fire:
		anim.play("shoot")
	elif Input.is_action_just_pressed("shoot_down") and can_fire:
		anim.play("shoot")
	elif Input.is_action_just_pressed("shoot_left") and can_fire:
		get_node("Sprite").set_flip_h(true)
		anim.play("shoot")
	elif Input.is_action_just_pressed("shoot_right") and can_fire:
		get_node("Sprite").set_flip_h(false)
		anim.play("shoot")
	#elif anim.current_animation == "shoot":
		#pass
	elif(Input.is_action_pressed("move_left")):
		get_node("Sprite").set_flip_h(true)
		anim.play("walk")
	elif (Input.is_action_pressed("move_right")):
		get_node("Sprite").set_flip_h(false)
		anim.play("walk")
	else:
		anim.play("idle")
