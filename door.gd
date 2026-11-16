extends Area2D

@export var target_scene: String
@export var spawn_position: Vector2 = Vector2.ZERO
@export var travel_cost_minutes: int = 30   # 0 untuk pintu rumah
@export var is_house_exit: bool = false     # centang di pintu DALAM rumah

@onready var prompt: Node2D = get_node_or_null("InteractUI")

var is_player_in_range: bool = false
var is_traveling: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if prompt:
		prompt.hide()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		is_player_in_range = true
		if prompt:
			prompt.show()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		is_player_in_range = false
		if prompt:
			prompt.hide()

func _input(event: InputEvent) -> void:
	if not (is_player_in_range and event.is_action_pressed("interact")):
		return
	if event is InputEventKey and event.echo:
		return
	if target_scene == "" or is_traveling:
		return

	# The Plaza is guarded by Cak Jon until Day 7 at 5:00 PM.
	# Handle this before NPC unhandled input to avoid duplicate conversations.
	if target_scene.get_file().get_basename().to_lower() == "plaza" and not StoryManager.is_plaza_unlocked():
		get_viewport().set_input_as_handled()
		StoryManager.show_plaza_gate_dialogue()
		return

	if is_house_exit and TimeManager.curfew_active:
		get_viewport().set_input_as_handled()
		print("It's too dark to go outside.")
		return

	get_viewport().set_input_as_handled()
	is_traveling = true
	if prompt:
		prompt.hide()

	if travel_cost_minutes > 0:
		TimeManager.advance_minutes(travel_cost_minutes)
		if TimeManager.curfew_active:
			is_traveling = false
			return

	if spawn_position != Vector2.ZERO:
		Global.target_spawn_position = spawn_position
		Global.use_spawn_position = true

	var main_scene = get_tree().current_scene
	if main_scene and main_scene.has_method("fade_out"):
		await main_scene.fade_out()

	var change_error: Error = get_tree().change_scene_to_file(target_scene)
	if change_error != OK:
		is_traveling = false
		Global.use_spawn_position = false
		push_error("Could not travel to %s: %s" % [target_scene, error_string(change_error)])
