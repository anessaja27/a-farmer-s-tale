extends CharacterBody2D

@export var walk_speed: float = 80.0
@export var run_speed: float = 120.0
@export var tile_size: int = 16 # Sesuaikan dengan ukuran tile Anda (16 atau 32)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var tile_indicator: Node2D = $TileIndicator # Node2D atau Sprite2D indikator

var last_direction: String = "down"
var is_using_tool: bool = false

func _ready():
	# Cek apakah ada koordinat spawn yang disimpan dari pintu
	if Global.use_spawn_position:
		global_position = Global.target_spawn_position
		Global.use_spawn_position = false # Reset kembali
	
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(_delta: float) -> void:
	# Perbarui posisi indikator kotak setiap frame
	update_tile_indicator()

	if is_using_tool:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var is_running := Input.is_action_pressed("run")
	
	var current_speed := run_speed if is_running else walk_speed
	
	if input_direction != Vector2.ZERO:
		# BULATKAN vektor pergerakan agar tidak ada angka desimal gantung
		var move_velocity = input_direction * current_speed
		velocity = move_velocity.round()
		
		update_direction(input_direction)
		play_animation(is_running)
	else:
		velocity = Vector2.ZERO
		play_idle_animation()
	move_and_slide()

# --- FUNGSI UPDATE INDIKATOR TILE ---
func update_tile_indicator() -> void:
	# 1. Ambil koordinat grid tile tempat kaki player berdiri
	var player_grid := (global_position / tile_size).floor()
	
	# 2. Geser 1 kotak ke depan berdasarkan arah pandang
	var target_grid := player_grid
	match last_direction:
		"right": target_grid += Vector2(1, 0)
		"left":  target_grid += Vector2(-1, 0)
		"down":  target_grid += Vector2(0, 1)
		"up":    target_grid += Vector2(0, -1)
	
	# 3. Konversi kembali dari koordinat grid ke posisi dunia (tengah tile)
	tile_indicator.global_position = (target_grid * tile_size) + Vector2(tile_size / 2.0, tile_size / 2.0)

func _unhandled_input(event: InputEvent) -> void:
	# Cek apakah menekan klik kiri mouse
	var is_mouse_click: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	
	# Cek apakah menekan tombol keyboard/gamepad yang terdaftar di action "use"
	var is_interact_pressed: bool = event.is_action_pressed("use")
	
	if is_mouse_click or is_interact_pressed:
		if not is_using_tool:
			use_pickaxe()
			# Mencegah input diteruskan ke UI atau node lain
			get_viewport().set_input_as_handled()

func use_pickaxe() -> void:
	is_using_tool = true
	animated_sprite.play("pickaxe_" + last_direction)

func _on_animation_finished() -> void:
	if animated_sprite.animation.begins_with("pickaxe_"):
		is_using_tool = false
		play_idle_animation()

func update_direction(direction: Vector2) -> void:
	if abs(direction.x) >= abs(direction.y):
		if direction.x > 0:
			last_direction = "right"
		elif direction.x < 0:
			last_direction = "left"
	else:
		if direction.y > 0:
			last_direction = "down"
		elif direction.y < 0:
			last_direction = "up"

func play_animation(is_running: bool) -> void:
	var action_state := "run" if is_running else "walk"
	var anim_name := action_state + "_" + last_direction
	animated_sprite.play(anim_name)

func play_idle_animation() -> void:
	var anim_name := "idle_" + last_direction
	animated_sprite.play(anim_name)
