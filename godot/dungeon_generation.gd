extends Node

var room = preload("res://Room.tscn")

var min_number_rooms = 6
var max_number_rooms = 12

var generation_chance = 20

func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var size = floor(rand_range(min_number_rooms, max_number_rooms))

	# Raum im Ursprung 0,0
	dungeon[Vector2(0,0)] = room.instance()
	size -= 1

	# für jeden neuen Raum
	while(size > 0):
		# für jeden vorhandenen Raum im Dungeon
		for i in dungeon.keys():
			if(rand_range(0,100) < generation_chance):
				var direction = rand_range(0,4)
				if(direction < 1):
					# Von aktuellen Raum (i) neuer Raum in Richtung (1, 0) [rechts]
					var new_room_position = i + Vector2(1, 0)
					if(!dungeon.has(new_room_position)):
						dungeon[new_room_position] = room.instance()
						size -= 1
					if(dungeon.get(i).connected_rooms.get(Vector2(1, 0)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(1, 0))
				elif(direction < 2):
					var new_room_position = i + Vector2(-1, 0)
					if(!dungeon.has(new_room_position)):
						dungeon[new_room_position] = room.instance()
						size -= 1
					if(dungeon.get(i).connected_rooms.get(Vector2(-1, 0)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(-1, 0))
				elif(direction < 3):
					var new_room_position = i + Vector2(0, 1)
					if(!dungeon.has(new_room_position)):
						dungeon[new_room_position] = room.instance()
						size -= 1
					if(dungeon.get(i).connected_rooms.get(Vector2(0, 1)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(0, 1))
				elif(direction < 4):
					var new_room_position = i + Vector2(0, -1)
					if(!dungeon.has(new_room_position)):
						dungeon[new_room_position] = room.instance()
						size -= 1
					if(dungeon.get(i).connected_rooms.get(Vector2(0, -1)) == null):
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(0, -1))
	# solange neu generieren bis der dungeon "interessant ist s.u."
	while(!is_interesting(dungeon)):
		for i in dungeon.keys():
			# instanzen der Räume wieder löschen
			dungeon.get(i).queue_free()
		# neuer random seed (weil gleicher seed = gleicher dungeon)
		var new_seed = room_seed * rand_range(-1,1) + rand_range(-100,100)
		dungeon = generate(new_seed)
	return dungeon

# 2 Räume miteinander verbinden
func connect_rooms(room1, room2, direction):
	room1.connected_rooms[direction] = room2
	room2.connected_rooms[-direction] = room1
	room1.number_of_connections += 1
	room2.number_of_connections += 1

func is_interesting(dungeon):
	# Ein Dungeon ist interessant, wenn mindestens 2 Räume mindestens 3 Verbindungen haben
	var room_with_three = 0
	for i in dungeon.keys():
		if(dungeon.get(i).number_of_connections >= 3):
			room_with_three += 1
	return room_with_three >= 2
