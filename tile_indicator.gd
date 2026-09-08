extends Node2D

@export var tile_size: int = 16 # Sesuaikan dengan 16 atau 32
@export var border_color: Color = Color(1, 1, 1, 0.8) # Warna putih transparan

func _draw() -> void:
	# Menggambar kotak outline tanpa isi (wireframe)
	var rect = Rect2(-tile_size / 2.0, -tile_size / 2.0, tile_size, tile_size)
	draw_rect(rect, border_color, false, 0.75) # angka 1.5 adalah ketebalan garis
