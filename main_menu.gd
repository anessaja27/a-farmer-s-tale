extends Control

const NEW_GAME_SCENE: String = "res://new_game_intro.tscn"

@onready var new_game_button: Button = $Buttons/NewGame
@onready var continue_button: Button = $Buttons/Continue
@onready var settings_button: Button = $Buttons/Settings
@onready var quit_button: Button = $Buttons/Quit
@onready var quit_confirm: Control = $QuitConfirmMenu
@onready var settings_menu: Control = $SettingsLayer/SettingsMenu
@onready var fade_layer: Node = $FadeLayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	quit_confirm.hide()
	settings_menu.hide()
	_style_menu_buttons()
	_refresh_continue_button()
	new_game_button.grab_focus()


func _style_menu_buttons() -> void:
	# The button artwork is already part of the background texture.
	# Keep these Buttons as invisible hitboxes: no border or default focus outline.
	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = Color(0.25, 0.13, 0.07, 0.0)
	normal_style.set_border_width_all(0)
	normal_style.set_corner_radius_all(0)

	var hover_style := StyleBoxFlat.new()
	hover_style.bg_color = Color(1.0, 0.92, 0.72, 0.07)
	hover_style.set_border_width_all(0)
	hover_style.set_corner_radius_all(0)

	var pressed_style := StyleBoxFlat.new()
	pressed_style.bg_color = Color(0.20, 0.10, 0.04, 0.14)
	pressed_style.set_border_width_all(0)
	pressed_style.set_corner_radius_all(0)

	var focus_style := StyleBoxFlat.new()
	focus_style.bg_color = Color(1.0, 0.92, 0.72, 0.045)
	focus_style.set_border_width_all(0)
	focus_style.set_corner_radius_all(0)

	var disabled_style := StyleBoxFlat.new()
	disabled_style.bg_color = Color(0.18, 0.14, 0.11, 0.30)
	disabled_style.set_border_width_all(0)
	disabled_style.set_corner_radius_all(0)

	for button: Button in [new_game_button, continue_button, settings_button, quit_button]:
		button.text = ""
		button.focus_mode = Control.FOCUS_ALL
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.add_theme_stylebox_override("normal", normal_style)
		button.add_theme_stylebox_override("hover", hover_style)
		button.add_theme_stylebox_override("pressed", pressed_style)
		button.add_theme_stylebox_override("hover_pressed", pressed_style)
		button.add_theme_stylebox_override("focus", focus_style)
		button.add_theme_stylebox_override("disabled", disabled_style)


func _refresh_continue_button() -> void:
	var latest_slot: int = SaveManager.get_latest_save_slot()
	continue_button.disabled = latest_slot < 1
	if latest_slot < 1:
		continue_button.tooltip_text = "No save found. Start a new game first."
		return

	var info: Dictionary = SaveManager.get_slot_info(latest_slot)
	var day: int = int(info.get("day", 1))
	var time_text: String = str(info.get("time_text", "Unknown time"))
	continue_button.tooltip_text = "Continue from Slot %d — Day %d — %s" % [latest_slot, day, time_text]


func _on_new_game_pressed() -> void:
	Global.use_spawn_position = false
	Global.target_spawn_position = Vector2.ZERO
	TimeManager.load_save_data({
		"day": 1,
		"hour": TimeManager.START_HOUR,
		"minute": 0,
	})
	StoryManager.start_new_story()
	# Keep the in-game clock stopped while the player reads the new-game intro.
	TimeManager.paused = true
	for slot in range(1, SaveManager.SLOT_COUNT + 1):
		if not SaveManager.has_save(slot):
			SaveManager.current_slot = slot
			break
	await _change_scene_with_fade(NEW_GAME_SCENE)


func _on_continue_pressed() -> void:
	var latest_slot: int = SaveManager.get_latest_save_slot()
	if latest_slot < 1:
		_refresh_continue_button()
		return

	await fade_layer.call("fade_out")
	if not SaveManager.load_game(latest_slot):
		continue_button.disabled = true
		continue_button.tooltip_text = "This save could not be loaded."
		await fade_layer.call("fade_in")


func _on_settings_pressed() -> void:
	quit_confirm.hide()
	settings_menu.show()


func _on_quit_pressed() -> void:
	settings_menu.hide()
	quit_confirm.show()


func _change_scene_with_fade(scene_path: String) -> void:
	await fade_layer.call("fade_out")
	var change_error: Error = get_tree().change_scene_to_file(scene_path)
	if change_error != OK:
		push_error("Could not open scene %s: %s" % [scene_path, error_string(change_error)])
		await fade_layer.call("fade_in")


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel") or event.is_echo():
		return

	if settings_menu.visible:
		settings_menu.call("handle_cancel")
		get_viewport().set_input_as_handled()
	elif quit_confirm.visible:
		quit_confirm.hide()
		get_viewport().set_input_as_handled()
