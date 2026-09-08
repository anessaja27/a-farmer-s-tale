extends Area2D

@export var target_scene: String
@export var spawn_position: Vector2 = Vector2.ZERO

var is_player_in_range: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		is_player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		is_player_in_range = false

func _unhandled_input(event):
	if is_player_in_range and event.is_action_pressed("interact"):
		if target_scene != "":
			if spawn_position != Vector2.ZERO:
				Global.target_spawn_position = spawn_position
				Global.use_spawn_position = true
			
			# Jalankan fade out jika parent scene punya fungsinya
			var main_scene = get_tree().current_scene
			if main_scene.has_method("fade_out"):
				await main_scene.fade_out()
			
			get_tree().change_scene_to_file(target_scene)
