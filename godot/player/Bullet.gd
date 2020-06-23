
extends RigidBody2D

#var explosion = preload("res://Explosion.tscn")

func _ready():
	$Tween.interpolate_callback(self, Game.p_bullet_ttl, "queue_free")
	$Tween.start()