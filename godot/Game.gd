extends Node

var dungeon = {}
var current_scene = null
var player_res = preload("res://player/Player.tscn")
var player = null

# Sollte eigentlich in Menü Szene aufgerufen werden.
func _ready():
	randomize()
	dungeon = dungeon_generation.generate(rand_range(-1000, 1000))
	change_to_instance(dungeon.get(Vector2(0, 0)))

func change_to_instance(instance):
	call_deferred("_deffered_change", instance)

func _deffered_change(instance):
	var root = get_node("/root")
	if current_scene != null:
		root.remove_child(current_scene)
		player.queue_free()
	player = player_res.instance()
	player.position = Vector2(920, 500)
	root.add_child(player)
	root.add_child(instance)
	get_tree().set_current_scene(instance)
	current_scene = instance
