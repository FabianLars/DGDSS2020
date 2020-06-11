extends Node

var dungeon = {}
var current_scene = null
var player_res = preload("res://player/Player.tscn")
var player = null

# Player Variablen ab hier; namen starten mit 'p_'
var p_bullet_ttl = 1.5 # Bullet time to live
var p_bullet_speed = 1000 # Bullet speed
var p_fire_rate = 1 # Schussrate
var p_max_speed = 500 # Maximale Charakter Geschwindigkeit
var p_acceleration = 2000 # Maximale Beschleunigung des Charakters; consider const


# Sollte eigentlich in Menü Szene aufgerufen werden.
func _ready():
	randomize()
	dungeon = dungeon_generation.generate(rand_range(-1000, 1000))
	change_to_room(dungeon.get(Vector2(0, 0)))

func change_to_room(instance, player_pos = Vector2(920, 500)):
	call_deferred("_deffered_change", instance, player_pos)

func _deffered_change(instance, pos):
	var root = get_node("/root")
	if current_scene != null:
		root.remove_child(current_scene)
		player.queue_free()
	player = player_res.instance()
	player.position = pos
	root.add_child(player)
	root.add_child(instance)
	get_tree().set_current_scene(instance)
	current_scene = instance
