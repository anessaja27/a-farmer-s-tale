extends Node

# I'm assuming this is the room with your bed. Change it if it's wrong.
const HOUSE_SCENE := "res://house_interior.tscn"

func _ready() -> void:
	TimeManager.curfew_started.connect(_on_curfew_started)

func _on_curfew_started() -> void:
	TimeManager.paused = true
	var current := get_tree().current_scene
	# Only teleport if the player isn't already in the house
	if current == null or current.scene_file_path != HOUSE_SCENE:
		if current and current.has_method("fade_out"):
			await current.fade_out()
		get_tree().change_scene_to_file(HOUSE_SCENE)
		await get_tree().scene_changed
	TimeManager.jump_to_bedtime()   # clock now reads 9:00 PM
	# TODO: replace with a real dialogue box
	print("It's getting too late, I should go home before it's too late.")
	await get_tree().create_timer(3.0).timeout
	TimeManager.paused = false
