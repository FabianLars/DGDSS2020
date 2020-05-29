extends KinematicBody2D

const MAX_SPEED = 500 # evtl var statt const, siehe bullet_speed
const ACCELERATION = 2000
var motion = Vector2.ZERO
export var bullet_speed = 1000 # var damit items das buffen können
export var fire_rate = 0.5 # var damit items das buffen können

var bullet = preload("res://player/Bullet.tscn")
var can_fire = true

func _process(_delta):
    if Input.is_action_pressed("shoot_left") and can_fire:
        var bullet_instance = bullet.instance()
        bullet_instance.position = $BulletPoint.get_global_position()
        bullet_instance.rotation_degrees = 180
        bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, -motion.y/1.8).rotated(deg2rad(180)))
        get_tree().get_root().add_child(bullet_instance)
        can_fire = false
        yield(get_tree().create_timer(fire_rate), "timeout")
        can_fire = true
    if Input.is_action_pressed("shoot_right") and can_fire:
        var bullet_instance = bullet.instance()
        bullet_instance.position = $BulletPoint.get_global_position()
        bullet_instance.rotation_degrees = 0
        bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, motion.y/1.8).rotated(deg2rad(0)))
        get_tree().get_root().add_child(bullet_instance)
        can_fire = false
        yield(get_tree().create_timer(fire_rate), "timeout")
        can_fire = true
    if Input.is_action_pressed("shoot_up") and can_fire:
        var bullet_instance = bullet.instance()
        bullet_instance.position = $BulletPoint.get_global_position()
        bullet_instance.rotation_degrees = -90
        bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, motion.x/1.8).rotated(deg2rad(-90)))
        get_tree().get_root().add_child(bullet_instance)
        can_fire = false
        yield(get_tree().create_timer(fire_rate), "timeout")
        can_fire = true
    if Input.is_action_pressed("shoot_down") and can_fire:
        var bullet_instance = bullet.instance()
        bullet_instance.position = $BulletPoint.get_global_position()
        bullet_instance.rotation_degrees = 90
        bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, -motion.x/1.8).rotated(deg2rad(90)))
        get_tree().get_root().add_child(bullet_instance)
        can_fire = false
        yield(get_tree().create_timer(fire_rate), "timeout")
        can_fire = true

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
