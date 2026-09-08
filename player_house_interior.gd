extends Node2D

@onready var interact_ui = $BedArea/InteractUI
@onready var color_rect: ColorRect = $FadeLayer/ColorRect
@onready var player: CharacterBody2D = $CharacterBody2D

var is_player_near_bed: bool = false
var is_sleeping: bool = false

func fade_out() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween = create_tween()
	await tween.tween_property(color_rect, "color:a", 1.0, 0.5).finished

func fade_in() -> void:
	var tween = create_tween()
	await tween.tween_property(color_rect, "color:a", 0.0, 0.5).finished
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _ready() -> void:
	# Layar hitam dibikin transparan penuh saat pertama masuk ruangan
	color_rect.color.a = 0.0
	# Sembunyikan UI papan kayu di awal
	interact_ui.hide()
	fade_in()

# Karakter mendekati area kasur
func _on_bed_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_sleeping:
		is_player_near_bed = true
		interact_ui.show()

# Karakter menjauhi area kasur
func _on_bed_area_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		is_player_near_bed = false
		interact_ui.hide()

# Menangkap input keyboard (Tombol E)
func _unhandled_input(event: InputEvent) -> void:
	if is_player_near_bed and not is_sleeping and event.is_action_pressed("interact"):
		start_sleeping_sequence()

# Proses Fade Layar & Tidur
func start_sleeping_sequence() -> void:
	is_sleeping = true
	interact_ui.hide() # Sembunyikan UI saat tidur
	
	# Matikan kontrol pergerakan player
	player.set_physics_process(false)
	
	# 1. Fade Out: Layar berubah pelan-pelan jadi hitam pekat (1 detik)
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, 1.0)
	await tween.finished
	
	# 2. Jeda waktu malam (1 detik) -> Tempat menaruh fungsi ganti hari/stamina nanti
	await get_tree().create_timer(1.0).timeout
	
	# 3. Fade In: Layar kembali terang pelan-pelan (1 detik)
	var tween_back = create_tween()
	tween_back.tween_property(color_rect, "color:a", 0.0, 1.0)
	await tween_back.finished
	
	# Kembalikan pergerakan player
	player.set_physics_process(true)
	is_sleeping = false
