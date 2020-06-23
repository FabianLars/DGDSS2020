extends KinematicBody2D

var speed = 200
var health = 3
var velocity = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	velocity = Vector2.ZERO
	velocity = (Game.player.position - position).normalized() * speed
	velocity = move_and_slide(velocity)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		Game.reduce_health(1)
	if body.is_in_group("Bullet"):
		health-=1
		body.queue_free()
		if health < 1:
			queue_free()
