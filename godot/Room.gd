extends Node2D

var connected_rooms = {
	Vector2(-1, 0): null,#links
	Vector2(1, 0): null,#rechts
	Vector2(0, -1): null,#oben
	Vector2(0, 1): null,#unten
}

var number_of_connections = 0

func _ready():
	if connected_rooms.get(Vector2(-1, 0)) != null:
		remove_child($TuerLinks)
	if connected_rooms.get(Vector2(1, 0)) != null:
		remove_child($TuerRechts)
	if connected_rooms.get(Vector2(0, 1)) != null:
		remove_child($TuerUnten)
	if connected_rooms.get(Vector2(0, -1)) != null:
		remove_child($TuerOben)


func _on_AreaLinks_body_entered(body):
	if body.is_in_group("Player"):
		for b in get_tree().get_nodes_in_group("Bullet"):
			b.queue_free()
		Game.change_to_instance(connected_rooms.get(Vector2(-1, 0)))

func _on_AreaRechts_body_entered(body):
	if body.is_in_group("Player"):
		for b in get_tree().get_nodes_in_group("Bullet"):
			b.queue_free()
		Game.change_to_instance(connected_rooms.get(Vector2(1, 0)))

func _on_AreaOben_body_entered(body):
	if body.is_in_group("Player"):
		for b in get_tree().get_nodes_in_group("Bullet"):
			b.queue_free()
		Game.change_to_instance(connected_rooms.get(Vector2(0, -1)))

func _on_AreaUnten_body_entered(body):
	if body.is_in_group("Player"):
		for b in get_tree().get_nodes_in_group("Bullet"):
			b.queue_free()
		Game.change_to_instance(connected_rooms.get(Vector2(0, 1)))
