extends Control

const SAVE_TEXTURE: Texture2D = preload("res://assets/ui/ui_only/save_game.png")
const LOAD_TEXTURE: Texture2D = preload("res://assets/ui/ui_only/load_game.png")
const PIXEL_FONT: FontFile = preload("res://assets/font/tinypixel.otf")
const CONFIRMATION_SCENE: PackedScene = preload("res://overwrite_confirmation.tscn")

@onready var backdrop: TextureRect = $Backdrop
@onready var panel_content: Control = $PanelContent

var mode: String = "save"
var selected_slot: int = 1
var pending_action: String = ""
var confirmation: Control
var slot_buttons: Array[Button] = []
var slot_title_labels: Array[Label] = []
var slot_detail_labels: Array[Label] = []
var slot_date_labels: Array[Label] = []
var action_button: Button
var delete_button: Button
var status_label: Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_slot_rows()
	_build_footer_buttons()
	confirmation = CONFIRMATION_SCENE.instantiate() as Control
	confirmation.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(confirmation)
	confirmation.hide()
	confirmation.connect("confirmed", Callable(self, "_on_confirmation_confirmed"))
	confirmation.connect("cancelled", Callable(self, "_on_confirmation_cancelled"))
	_refresh_slots()


func open_menu(open_mode: String) -> void:
	mode = "load" if open_mode == "load" else "save"
	backdrop.texture = LOAD_TEXTURE if mode == "load" else SAVE_TEXTURE
	selected_slot = clampi(SaveManager.current_slot, 1, SaveManager.SLOT_COUNT)

	if mode == "load" and not SaveManager.has_save(selected_slot):
		for slot in range(1, SaveManager.SLOT_COUNT + 1):
			if SaveManager.has_save(slot):
				selected_slot = slot
				break

	status_label.text = "SLOT %d OF %d" % [selected_slot, SaveManager.SLOT_COUNT]
	pending_action = ""
	confirmation.hide()
	_refresh_slots()
	show()


func handle_cancel() -> void:
	if confirmation != null and confirmation.visible:
		confirmation.call("close_dialog")
	else:
		hide()


func _build_slot_rows() -> void:
	for slot in range(1, SaveManager.SLOT_COUNT + 1):
		var card := Button.new()
		card.position = Vector2(91, 86 + (slot - 1) * 105)
		card.size = Vector2(810, 93)
		card.text = ""
		card.focus_mode = Control.FOCUS_NONE
		card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		card.add_theme_stylebox_override("normal", _make_slot_style(false, false))
		card.add_theme_stylebox_override("hover", _make_slot_style(false, true))
		card.add_theme_stylebox_override("pressed", _make_slot_style(true, false))
		card.pressed.connect(_on_slot_pressed.bind(slot))
		panel_content.add_child(card)
		slot_buttons.append(card)

		var title := _make_label(21, Color("#553824"))
		title.position = Vector2(22, 10)
		title.size = Vector2(620, 30)
		card.add_child(title)
		slot_title_labels.append(title)

		var detail := _make_label(16, Color("#76543c"))
		detail.position = Vector2(22, 43)
		detail.size = Vector2(750, 25)
		card.add_child(detail)
		slot_detail_labels.append(detail)

		var date_label := _make_label(13, Color("#8c684f"))
		date_label.position = Vector2(630, 12)
		date_label.size = Vector2(155, 23)
		date_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		card.add_child(date_label)
		slot_date_labels.append(date_label)


func _build_footer_buttons() -> void:
	# These transparent hit areas sit on top of the labels already drawn into
	# save_game.png / load_game.png, preserving the supplied pixel-art design.
	var back_button := _make_art_button(Vector2(91, 472), Vector2(168, 40))
	back_button.pressed.connect(_on_back_pressed)
	panel_content.add_child(back_button)

	delete_button = _make_art_button(Vector2(561, 472), Vector2(166, 40))
	delete_button.pressed.connect(_on_delete_pressed)
	panel_content.add_child(delete_button)

	action_button = _make_art_button(Vector2(734, 472), Vector2(166, 40))
	action_button.pressed.connect(_on_action_pressed)
	panel_content.add_child(action_button)

	# The supplied background says "Page 1 / 3" and includes page arrows.
	# This project has exactly three slots on one screen, so cover that strip
	# and use it as a small status line instead.
	var status_patch := ColorRect.new()
	status_patch.position = Vector2(389, 420)
	status_patch.size = Vector2(214, 34)
	status_patch.color = Color("#f4dfbd")
	status_patch.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel_content.add_child(status_patch)

	status_label = _make_label(15, Color("#70482f"))
	status_label.position = Vector2(389, 420)
	status_label.size = Vector2(214, 34)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel_content.add_child(status_label)


func _make_art_button(button_position: Vector2, button_size: Vector2) -> Button:
	var button := Button.new()
	button.position = button_position
	button.size = button_size
	button.text = ""
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_stylebox_override("normal", _make_transparent_style(0.0))
	button.add_theme_stylebox_override("hover", _make_transparent_style(0.18))
	button.add_theme_stylebox_override("pressed", _make_transparent_style(0.28))
	return button


func _make_transparent_style(alpha: float) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.35, 0.19, 0.11, alpha)
	style.set_corner_radius_all(5)
	return style


func _make_slot_style(is_selected: bool, is_hovered: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	if is_selected:
		style.bg_color = Color("#e3ebd4")
	elif is_hovered:
		style.bg_color = Color("#f8e8c8")
	else:
		style.bg_color = Color("#f1dcb7")
	style.border_color = Color("#718653") if is_selected else Color("#a47755")
	style.set_border_width_all(4 if is_selected else 2)
	style.set_corner_radius_all(6)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style


func _make_label(font_size: int, font_color: Color) -> Label:
	var label := Label.new()
	label.add_theme_font_override("font", PIXEL_FONT)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label


func _refresh_slots() -> void:
	for index in range(SaveManager.SLOT_COUNT):
		var slot := index + 1
		var has_data: bool = SaveManager.has_save(slot)
		var info: Dictionary = SaveManager.get_slot_info(slot)
		var is_selected := slot == selected_slot

		slot_buttons[index].add_theme_stylebox_override("normal", _make_slot_style(is_selected, false))
		slot_buttons[index].add_theme_stylebox_override("hover", _make_slot_style(is_selected, true))
		slot_buttons[index].add_theme_stylebox_override("pressed", _make_slot_style(true, false))

		if not has_data:
			slot_title_labels[index].text = "SLOT %d    -    EMPTY SLOT" % slot
			slot_detail_labels[index].text = "No saved game in this slot yet."
			slot_date_labels[index].text = ""
		else:
			var day := int(info.get("day", 1))
			var time_text := str(info.get("time_text", "Unknown time"))
			var scene_name := str(info.get("scene_name", "Farm"))
			var saved_at := str(info.get("saved_at", ""))
			slot_title_labels[index].text = "SLOT %d    -    DAY %d" % [slot, day]
			slot_detail_labels[index].text = "%s    |    %s" % [time_text, scene_name]
			slot_date_labels[index].text = saved_at.replace("T", " ")

	action_button.disabled = false
	delete_button.visible = mode == "load"
	delete_button.disabled = false


func _on_slot_pressed(slot: int) -> void:
	selected_slot = slot
	status_label.text = "SLOT %d SELECTED" % slot
	_refresh_slots()


func _on_back_pressed() -> void:
	if confirmation.visible:
		confirmation.call("close_dialog")
	hide()


func _on_action_pressed() -> void:
	if mode == "save":
		if SaveManager.has_save(selected_slot):
			pending_action = "save"
			confirmation.call("show_confirmation",
				"OVERWRITE SAVE?",
				"Slot %d already contains a save.\nReplacing it cannot be undone." % selected_slot
			)
		else:
			_perform_save()
	else:
		if SaveManager.has_save(selected_slot):
			if not SaveManager.load_game(selected_slot):
				status_label.text = "Could not load this save."
		else:
			status_label.text = "THIS SLOT IS EMPTY"


func _on_delete_pressed() -> void:
	if not SaveManager.has_save(selected_slot):
		status_label.text = "THIS SLOT IS EMPTY"
		return
	pending_action = "delete"
	confirmation.call("show_confirmation",
		"DELETE SAVE?",
		"Delete Slot %d permanently?\nThis save cannot be recovered." % selected_slot
	)


func _on_confirmation_confirmed() -> void:
	match pending_action:
		"save":
			_perform_save()
		"delete":
			if SaveManager.delete_save(selected_slot):
				status_label.text = "SLOT %d DELETED" % selected_slot
			else:
				status_label.text = "Could not delete this slot."
			_refresh_slots()
	pending_action = ""


func _on_confirmation_cancelled() -> void:
	pending_action = ""


func _perform_save() -> void:
	if SaveManager.save_game(selected_slot):
		status_label.text = "GAME SAVED TO SLOT %d" % selected_slot
	else:
		status_label.text = "SAVE FAILED - CHECK THE OUTPUT LOG"
	_refresh_slots()
