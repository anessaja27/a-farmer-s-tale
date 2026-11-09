extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

@export var fade_duration: float = 0.5


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Start with a black screen
	color_rect.color = Color.BLACK
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP

	fade_in()


func fade_out() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	await fade_to(1.0)


func fade_in() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	await fade_to(0.0)

	# Allow mouse clicks after the transition
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE


func fade_to(target_alpha: float) -> void:
	var tween = create_tween()
	tween.tween_property(
		color_rect,
		"color:a",
		target_alpha,
		fade_duration
	)
	await tween.finished


func _on_quit_pressed() -> void:
	pass # Replace with function body.
