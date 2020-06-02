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
		print("left")
		remove_child($TuerLinks)
	if connected_rooms.get(Vector2(1, 0)) != null:
		print("right")
		remove_child($TuerRechts)
	if connected_rooms.get(Vector2(0, 1)) != null:
		print("bottom")
		remove_child($TuerUnten)
	if connected_rooms.get(Vector2(0, -1)) != null:
		print("top")
		remove_child($TuerOben)


func _on_AreaLinks_body_entered(body):
	print(body)
	if body.is_in_group("Player"):
		Game.change_to_instance(connected_rooms.get(Vector2(-1, 0)))

func _on_AreaRechts_body_entered(body):
	if body.is_in_group("Player"):
		Game.change_to_instance(connected_rooms.get(Vector2(1, 0)))

func _on_AreaOben_body_entered(body):
	if body.is_in_group("Player"):
		Game.change_to_instance(connected_rooms.get(Vector2(0, -1)))

func _on_AreaUnten_body_entered(body):
	if body.is_in_group("Player"):
		Game.change_to_instance(connected_rooms.get(Vector2(0, 1)))
