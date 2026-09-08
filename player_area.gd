extends Node2D

@onready var color_rect: ColorRect = $FadeLayer/ColorRect

func _ready():
	# Jalankan efek layar terang kembali saat baru masuk ke scene luar
	fade_in()

func fade_out() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween = create_tween()
	await tween.tween_property(color_rect, "color:a", 1.0, 0.5).finished

func fade_in() -> void:
	var tween = create_tween()
	await tween.tween_property(color_rect, "color:a", 0.0, 0.5).finished
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
