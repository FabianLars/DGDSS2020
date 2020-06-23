extends Node

const MAIN_MENU_PATH = "res://menu/Menu.tscn"

const POPUP_SCENE = preload("res://menu/PauseMenu.tscn")
var popup = null

const OVERLAY_SCENE = preload("res://menu/Overlay.tscn")
var overlay = null

var canvas_layer = null

const DEBUG_DISPLAY_SCENE = preload("res://menu/DebugDisplay.tscn")
var debug_display = null

var menumusic = true
var debugdisplay = false

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
	canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	load_settings()


func start_game():
	set_overlay(false)
	load_settings()
	get_node("/root/MainMenuRoot").queue_free()
	randomize()
	dungeon = dungeon_generation.generate(rand_range(-1000, 1000))
	change_to_room(dungeon.get(Vector2(0, 0)))

func goto_scene(path):
	get_tree().change_scene(path)
	set_overlay(false)
	load_settings()

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

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and get_tree().get_current_scene().name != "MainMenuContainer":
		if popup == null:
			popup = POPUP_SCENE.instance()
			popup.get_node("Button_quit").connect("pressed", self, "popup_quit")
			popup.connect("popup_hide", self, "popup_closed")
			popup.get_node("Button_resume").connect("pressed", self, "popup_closed")

			canvas_layer.add_child(popup)
			popup.popup_centered()

			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

			get_tree().paused = true

func set_global_vol(val):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(val))

func popup_closed():
	get_tree().paused = false
	if popup != null:
		popup.queue_free()
		popup = null

func popup_quit():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if popup != null:
		popup.queue_free()
		popup = null
		player.queue_free()
		goto_scene(MAIN_MENU_PATH)

func set_debug_display(display_on):
	debugdisplay = display_on
	if display_on == false:
		if debug_display != null:
			debug_display.queue_free()
			debug_display = null
	else:
		if debug_display == null:
			debug_display = DEBUG_DISPLAY_SCENE.instance()
			canvas_layer.add_child(debug_display)
	
func save_settings():
	var settings_file = File.new()
	settings_file.open("user://settings.json", File.WRITE)
	var settings_nodes = get_tree().get_nodes_in_group("Settings")
	for i in settings_nodes:
		var node_data = i.call("save_settings_to_file");
		settings_file.store_line(to_json(node_data))
	settings_file.close()
	
func load_settings():
	var settings_file = File.new()
	if not settings_file.file_exists("user://settings.json"):
		return
	settings_file.open("user://settings.json", File.READ)
	while not settings_file.eof_reached():
		var current_line = parse_json(settings_file.get_line())
		if current_line != null:
			if current_line.has("volume_slider"):
				set_global_vol(current_line["volume_slider"])
			if current_line.has("menumusic"):
				menumusic = current_line["menumusic"]
			if current_line.has("fullscreen"):
				OS.window_fullscreen = current_line["fullscreen"]
			if current_line.has("debug"):
				set_debug_display(current_line["debug"])
			if current_line.has("vsync"):
				OS.vsync_enabled = (current_line["vsync"])
	settings_file.close()
	var settings_nodes = get_tree().get_nodes_in_group("Settings")
	for i in settings_nodes:
		var node_data = i.call("load_settings");

func set_overlay(overlay_on):
	if overlay_on == false:
		if overlay != null:
			overlay.queue_free()
			overlay = null
	else:
		if overlay == null:
			overlay = OVERLAY_SCENE.instance()
			canvas_layer.add_child(overlay)
