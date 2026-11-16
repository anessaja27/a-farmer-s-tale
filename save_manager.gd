extends Node

const SLOT_COUNT := 3
const SAVE_VERSION := 3
const HOUSE_SCENE := "res://house_interior.tscn"

# Any autoload that implements get_save_data() / load_save_data() can be listed here.
const SAVEABLE_AUTOLOADS := ["TimeManager", "StoryManager", "QuestManager"]

var current_slot: int = 1


func _slot_path(slot: int) -> String:
	return "user://save_slot_%d.save" % slot


func _is_valid_slot(slot: int) -> bool:
	return slot >= 1 and slot <= SLOT_COUNT


func has_save(slot: int) -> bool:
	return _is_valid_slot(slot) and FileAccess.file_exists(_slot_path(slot))


# Returns the most recently written readable save slot, or -1 when none exist.
func get_latest_save_slot() -> int:
	var latest_slot: int = -1
	var latest_timestamp: int = -1

	for slot in range(1, SLOT_COUNT + 1):
		var data: Dictionary = _read_slot(slot)
		if data.is_empty():
			continue

		var meta_value: Variant = data.get("meta", {})
		if not (meta_value is Dictionary):
			continue

		var timestamp: float = float(meta_value.get("saved_at_unix", 0.0))

		# Older saves without the precise timestamp fall back to file modified time.
		if timestamp <= 0.0:
			timestamp = float(FileAccess.get_modified_time(_slot_path(slot)))

		if timestamp > latest_timestamp:
			latest_timestamp = timestamp
			latest_slot = slot

	return latest_slot


func save_game(slot: int = -1) -> bool:
	if slot == -1:
		slot = current_slot
	if not _is_valid_slot(slot):
		push_warning("Save failed: slot %d is outside the valid range." % slot)
		return false

	var current_scene := get_tree().current_scene
	var scene_path := HOUSE_SCENE
	var scene_name := "Home"
	if current_scene != null and not current_scene.scene_file_path.is_empty():
		scene_path = current_scene.scene_file_path
		scene_name = scene_path.get_file().get_basename().replace("_", " ").capitalize()

	var data: Dictionary = {
		"version": SAVE_VERSION,
		"meta": {
			"day": TimeManager.day,
			"time_text": TimeManager.get_time_text(),
			"saved_at": Time.get_datetime_string_from_system(false, true),
			"saved_at_unix": Time.get_unix_time_from_system(),
			"scene_name": scene_name,
			"scene_path": scene_path,
		},
		"scene_path": scene_path,
	}

	# Store the player's world position so loading restores the same place,
	# rather than always moving the player back to the house.
	var players := get_tree().get_nodes_in_group("Player")
	if not players.is_empty():
		var player: Node = players[0]
		if player is Node2D:
			data["player"] = {"position": player.global_position}

	for system_name in SAVEABLE_AUTOLOADS:
		var node: Node = get_node_or_null("/root/" + system_name)
		if node != null and node.has_method("get_save_data"):
			data[system_name] = node.call("get_save_data")

	var file := FileAccess.open(_slot_path(slot), FileAccess.WRITE)
	if file == null:
		push_error("Save failed: %s" % error_string(FileAccess.get_open_error()))
		return false

	file.store_var(data)
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		push_error("Save failed while writing slot %d: %s" % [slot, error_string(write_error)])
		return false

	current_slot = slot
	print("Saved to slot %d" % slot)
	return true


func load_game(slot: int) -> bool:
	if not _is_valid_slot(slot):
		return false

	var data := _read_slot(slot)
	if data.is_empty():
		return false

	for system_name in SAVEABLE_AUTOLOADS:
		var node: Node = get_node_or_null("/root/" + system_name)
		if node != null and node.has_method("load_save_data") and data.has(system_name):
			var system_data: Variant = data[system_name]
			if system_data is Dictionary:
				node.call("load_save_data", system_data)

	# Older saves predate the story system. Reset its flags after restoring
	# their day/time so the Plaza unlock is derived from the loaded day.
	if not data.has("StoryManager") and has_node("/root/StoryManager"):
		get_node("/root/StoryManager").call("start_new_story")

	var scene_path := str(data.get("scene_path", HOUSE_SCENE))
	if scene_path.is_empty() or not ResourceLoader.exists(scene_path):
		scene_path = HOUSE_SCENE

	# Player._ready() consumes these values when the target scene is created.
	Global.use_spawn_position = false
	var player_data: Variant = data.get("player", {})
	if player_data is Dictionary and player_data.has("position"):
		var saved_position: Variant = player_data.get("position")
		if saved_position is Vector2:
			Global.target_spawn_position = saved_position
			Global.use_spawn_position = true

	current_slot = slot
	get_tree().paused = false
	var change_error := get_tree().change_scene_to_file(scene_path)
	if change_error != OK:
		Global.use_spawn_position = false
		push_error("Load failed: %s" % error_string(change_error))
		return false
	return true


func delete_save(slot: int) -> bool:
	if not has_save(slot):
		return false
	var absolute_path := ProjectSettings.globalize_path(_slot_path(slot))
	var error := DirAccess.remove_absolute(absolute_path)
	if error != OK:
		push_error("Could not delete slot %d: %s" % [slot, error_string(error)])
		return false
	return true


# Returns the metadata shown by the save/load menu, or an empty Dictionary.
func get_slot_info(slot: int) -> Dictionary:
	var data := _read_slot(slot)
	var meta: Variant = data.get("meta", {})
	return meta if meta is Dictionary else {}


func _read_slot(slot: int) -> Dictionary:
	if not has_save(slot):
		return {}

	var file := FileAccess.open(_slot_path(slot), FileAccess.READ)
	if file == null:
		push_warning("Could not open slot %d: %s" % [slot, error_string(FileAccess.get_open_error())])
		return {}

	var data: Variant = file.get_var()
	file.close()
	return data if data is Dictionary else {}
