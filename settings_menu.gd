extends Control

const SETTINGS_PATH: String = "user://settings.cfg"
const DEFAULT_MASTER_VOLUME: float = 0.8
const DEFAULT_WINDOW_SIZE: Vector2i = Vector2i(1280, 720)

@onready var master_volume_slider: HSlider = $CenterContainer/Panel/Margin/VBox/AudioSection/MasterVolumeRow/MasterVolumeSlider
@onready var master_volume_value: Label = $CenterContainer/Panel/Margin/VBox/AudioSection/MasterVolumeRow/MasterVolumeValue
@onready var fullscreen_toggle: CheckButton = $CenterContainer/Panel/Margin/VBox/DisplaySection/FullscreenToggle

var _is_initializing: bool = true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_settings()


func _load_settings() -> void:
	var config := ConfigFile.new()
	var load_error: Error = config.load(SETTINGS_PATH)

	var current_mode: int = DisplayServer.window_get_mode()
	var current_fullscreen: bool = (
		current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN
		or current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	)
	var saved_volume: float = DEFAULT_MASTER_VOLUME
	var saved_fullscreen: bool = current_fullscreen

	if load_error == OK:
		saved_volume = float(config.get_value("audio", "master_volume", DEFAULT_MASTER_VOLUME))
		saved_fullscreen = bool(config.get_value("display", "fullscreen", current_fullscreen))

	_is_initializing = true
	master_volume_slider.value = clampf(saved_volume * 100.0, 0.0, 100.0)
	fullscreen_toggle.button_pressed = saved_fullscreen
	_is_initializing = false

	_apply_master_volume(master_volume_slider.value)
	_apply_fullscreen(saved_fullscreen)
	_update_volume_label(master_volume_slider.value)


func _on_master_volume_changed(value: float) -> void:
	_update_volume_label(value)
	if _is_initializing:
		return

	_apply_master_volume(value)
	_save_settings()


func _on_fullscreen_toggled(enabled: bool) -> void:
	if _is_initializing:
		return

	_apply_fullscreen(enabled)
	_save_settings()


func _on_defaults_pressed() -> void:
	_is_initializing = true
	master_volume_slider.value = DEFAULT_MASTER_VOLUME * 100.0
	fullscreen_toggle.button_pressed = true
	_is_initializing = false

	_apply_master_volume(master_volume_slider.value)
	_apply_fullscreen(true)
	_update_volume_label(master_volume_slider.value)
	_save_settings()


func _on_back_pressed() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if not visible or not event.is_action_pressed("ui_cancel") or event.is_echo():
		return

	hide()
	get_viewport().set_input_as_handled()


func handle_cancel() -> void:
	hide()


func _apply_master_volume(value: float) -> void:
	var master_bus_index: int = AudioServer.get_bus_index("Master")
	if master_bus_index < 0:
		return

	AudioServer.set_bus_volume_linear(master_bus_index, clampf(value / 100.0, 0.0, 1.0))
	AudioServer.set_bus_mute(master_bus_index, value <= 0.0)


func _apply_fullscreen(enabled: bool) -> void:
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(DEFAULT_WINDOW_SIZE)

		var screen_size: Vector2i = DisplayServer.screen_get_size()
		var centered_position := Vector2i(
			maxi(0, (screen_size.x - DEFAULT_WINDOW_SIZE.x) / 2),
			maxi(0, (screen_size.y - DEFAULT_WINDOW_SIZE.y) / 2)
		)
		DisplayServer.window_set_position(centered_position)


func _update_volume_label(value: float) -> void:
	master_volume_value.text = "%d%%" % roundi(value)


func _save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume_slider.value / 100.0)
	config.set_value("display", "fullscreen", fullscreen_toggle.button_pressed)

	var save_error: Error = config.save(SETTINGS_PATH)
	if save_error != OK:
		push_warning("Could not save settings. Error code: %s" % save_error)
