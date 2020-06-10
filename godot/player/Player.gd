extends KinematicBody2D

onready var anim = get_node("AnimationPlayer")
var motion = Vector2.ZERO
var state_machine

var bullet = preload("res://player/Bullet.tscn")
var can_fire = true

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	
func _process(_delta):
	if Input.is_action_pressed("shoot_left") and can_fire:
		can_fire = false
		yield(get_tree().create_timer(Game.p_fire_rate), "timeout")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = 180
		bullet_instance.apply_impulse(Vector2(), Vector2(Game.p_bullet_speed, -motion.y/1.8).rotated(deg2rad(180)))
		get_tree().get_root().add_child(bullet_instance)
		get_node("Sprite").set_flip_h(true)
		can_fire = true
	if Input.is_action_pressed("shoot_right") and can_fire:
		can_fire = false
		yield(get_tree().create_timer(Game.p_fire_rate), "timeout")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = 0
		bullet_instance.apply_impulse(Vector2(), Vector2(Game.p_bullet_speed, motion.y/1.8).rotated(deg2rad(0)))
		get_tree().get_root().add_child(bullet_instance)
		get_node("Sprite").set_flip_h(false)
		can_fire = true
	if Input.is_action_pressed("shoot_up") and can_fire:
		can_fire = false
		yield(get_tree().create_timer(Game.p_fire_rate), "timeout")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = -90
		bullet_instance.apply_impulse(Vector2(), Vector2(Game.p_bullet_speed, motion.x/1.8).rotated(deg2rad(-90)))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = true
	if Input.is_action_pressed("shoot_down") and can_fire:
		can_fire = false
		yield(get_tree().create_timer(Game.p_fire_rate), "timeout")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = 90
		bullet_instance.apply_impulse(Vector2(), Vector2(Game.p_bullet_speed, -motion.x/1.8).rotated(deg2rad(90)))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = true

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:# ZERO = (0,0) = basically der origin (zB Ruhepos vom Stick)
		apply_friction(Game.p_acceleration * delta)
	else:
		apply_movement(axis * Game.p_acceleration * delta)
	motion = move_and_slide(motion)

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	#Animationskram
	if axis == Vector2.ZERO:
		state_machine.travel("idle")
	elif(Input.is_action_pressed("move_left")):
		get_node("Sprite").set_flip_h(true)
		state_machine.travel("walk")
	elif (Input.is_action_pressed("move_right")):
		get_node("Sprite").set_flip_h(false)
		state_machine.travel("walk")
	else:
		state_machine.travel("walk")
	if Input.is_action_pressed("shoot_left"):
		get_node("Sprite").set_flip_h(true)
		state_machine.travel("shoot")
	elif Input.is_action_pressed("shoot_right"):
		get_node("Sprite").set_flip_h(false)
		state_machine.travel("shoot")
	elif Input.is_action_pressed("shoot_up") or Input.is_action_pressed("shoot_down"):
		state_machine.travel("shoot")
	
	return axis.normalized()

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(Game.p_max_speed)

func hurt():
	state_machine.travel("hurt") #Animation zu "hurt" ist noch nicht vorhanden
	
func die():
	state_machine.travel("die") #Animation zu "die" ist noch nicht vorhanden
	set_physics_process(false)