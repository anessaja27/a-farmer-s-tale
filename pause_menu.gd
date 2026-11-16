extends CanvasLayer

@onready var root: Control = $root
@onready var quit_confirm: Control = $root/QuitConfirmMenu
@onready var main_menu_confirm: Control = $root/MainMenuConfirm
@onready var save_menu: Control = $root/SaveMenu
@onready var settings_menu: Control = $root/SettingsMenu


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	root.hide()
	settings_menu.hide()
	quit_confirm.hide()
	main_menu_confirm.hide()
	save_menu.hide()


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel") or event.is_echo():
		return

	if settings_menu.visible:
		settings_menu.call("handle_cancel")
	elif save_menu.visible:
		save_menu.call("handle_cancel")
	elif quit_confirm.visible:
		quit_confirm.hide()
	elif main_menu_confirm.visible:
		main_menu_confirm.hide()
	else:
		toggle_pause()

	get_viewport().set_input_as_handled()


func toggle_pause() -> void:
	var is_paused := not get_tree().paused
	get_tree().paused = is_paused
	root.visible = is_paused
	if not is_paused:
		save_menu.hide()
		settings_menu.hide()
		quit_confirm.hide()
		main_menu_confirm.hide()


func resume_game() -> void:
	get_tree().paused = false
	root.hide()
	settings_menu.hide()
	quit_confirm.hide()
	main_menu_confirm.hide()
	save_menu.hide()


func open_settings_menu() -> void:
	quit_confirm.hide()
	main_menu_confirm.hide()
	save_menu.hide()
	settings_menu.show()


func open_save_menu() -> void:
	settings_menu.hide()
	quit_confirm.hide()
	main_menu_confirm.hide()
	save_menu.call("open_menu", "save")


func open_load_menu() -> void:
	settings_menu.hide()
	quit_confirm.hide()
	main_menu_confirm.hide()
	save_menu.call("open_menu", "load")


func _on_quit_game_pressed() -> void:
	quit_confirm.show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_cancel_button_pressed() -> void:
	quit_confirm.hide()


func _on_main_menu_pressed() -> void:
	main_menu_confirm.show()
