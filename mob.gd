extends CharacterBody2D

@export var speed := 25.0
@export var wander_radius := 64.0
@export var idle_time := Vector2(2.0, 5.0)  # min and max seconds standing still
@export var max_walk_time := 4.0            # gives up on a walk after this long

enum State { IDLE, WALK }

var state := State.IDLE
var home: Vector2
var target: Vector2
var direction := "down"
var timer := 0.0
var sprite: AnimatedSprite2D

func _ready() -> void:
	home = global_position   # wherever you placed them in the scene
	sprite = find_children("*", "AnimatedSprite2D", false, false)[0]
	_start_idle()

func _physics_process(delta: float) -> void:
	timer -= delta
	match state:
		State.IDLE:
			if timer <= 0.0:
				_start_walk()
		State.WALK:
			var to_target := target - global_position
			if to_target.length() < 2.0 or timer <= 0.0:
				_start_idle()
				return
			velocity = to_target.normalized() * speed
			move_and_slide()
			if get_slide_collision_count() > 0:
				_start_idle()

func _start_idle() -> void:
	state = State.IDLE
	velocity = Vector2.ZERO
	timer = randf_range(idle_time.x, idle_time.y)
	_play("idle")

func _start_walk() -> void:
	state = State.WALK
	var dist := randf_range(8.0, wander_radius)
	target = home + Vector2.from_angle(randf() * TAU) * dist
	timer = max_walk_time
	_update_direction(target - global_position)
	_play("walk")

func _update_direction(diff: Vector2) -> void:
	if abs(diff.x) > abs(diff.y):
		direction = "right" if diff.x > 0 else "left"
	else:
		direction = "down" if diff.y > 0 else "up"

func _play(prefix: String) -> void:
	var anim := _find_anim(prefix)
	if anim != "":
		sprite.play(anim)
	elif prefix == "idle":
		# No idle art: freeze the walk animation on one frame
		var walk_anim := _find_anim("walk")
		if walk_anim != "":
			sprite.animation = walk_anim
			sprite.stop()
			sprite.frame = 0

func _find_anim(prefix: String) -> String:
	var frames := sprite.sprite_frames
	sprite.flip_h = false
	var specific := prefix + "_" + direction
	if frames.has_animation(specific):
		return specific
	# Missing one side? Use the other side, mirrored
	if direction == "right" and frames.has_animation(prefix + "_left"):
		sprite.flip_h = true
		return prefix + "_left"
	if direction == "left" and frames.has_animation(prefix + "_right"):
		sprite.flip_h = true
		return prefix + "_right"
	if frames.has_animation(prefix + "_down"):
		return prefix + "_down"
	return ""
