extends CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Game.set_overlay(false)
	load_settings()
	
func load_settings():
	$MenuContainer/OptionsMenu/HSlider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$MenuContainer/OptionsMenu/CheckDebug.pressed = Game.debugdisplay
	$MenuContainer/OptionsMenu/CheckFullscreen.pressed = OS.window_fullscreen
	$MenuContainer/OptionsMenu/CheckVSync.pressed = OS.vsync_enabled
	$MenuContainer/OptionsMenu/CheckMenumusic.pressed = Game.menumusic
	$AudioStreamPlayer.playing = Game.menumusic

func main_menu_new_game_pressed():
	Game.start_game()

func main_menu_options_pressed():
	$MenuContainer/OptionsMenu.visible = true
	$MenuContainer/StartMenu.visible = false

func main_menu_quit_game_pressed():
	get_tree().quit()

func options_menu_button_pressed(button):
	if button == "vsync":
		OS.vsync_enabled = !OS.vsync_enabled
	elif button == "debug":
		Game.set_debug_display($MenuContainer/OptionsMenu/CheckDebug.pressed)
	elif button == "fullscreen":
		OS.window_fullscreen = !OS.window_fullscreen
	elif button == "menumusic":
		$AudioStreamPlayer.playing = !$AudioStreamPlayer.playing
	elif button == "back":
		Game.save_settings()
		$MenuContainer/StartMenu.visible = true
		$MenuContainer/OptionsMenu.visible = false
	else:
		pass

func _on_volume_slider_changed(val):
	Game.set_global_vol(val)
	
func save_settings_to_file():
	return {
		"volume_slider": db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))),
		"vsync": OS.vsync_enabled,
		"debug": Game.debugdisplay,
		"fullscreen": OS.window_fullscreen,
		"menumusic": $AudioStreamPlayer.playing,
	}
