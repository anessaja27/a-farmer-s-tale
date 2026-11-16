extends Node

signal time_changed(hour: int, minute: int)
signal day_started(day: int)
signal curfew_started
signal bedtime_reached

const START_HOUR := 8
const CURFEW_HOUR := 20   # 8 PM
const END_HOUR := 21      # 9 PM (clock shows this after the curfew teleport)
const SECONDS_PER_GAME_MINUTE := 0.7   # ~9 real minutes per day
const TRAVEL_COST_MINUTES := 30

var day: int = 1
var hour: int = START_HOUR
var minute: int = 0
var paused: bool = false
var curfew_active: bool = false
var day_over: bool = false

var _accumulator: float = 0.0

func _process(delta: float) -> void:
	if paused or day_over:
		return
	_accumulator += delta
	while _accumulator >= SECONDS_PER_GAME_MINUTE:
		_accumulator -= SECONDS_PER_GAME_MINUTE
		_advance_minute()
		if day_over or curfew_active:
			break

func _advance_minute() -> void:
	minute += 1
	if minute >= 60:
		minute = 0
		hour += 1
	if hour >= CURFEW_HOUR and not curfew_active:
		curfew_active = true
		curfew_started.emit()
	time_changed.emit(hour, minute)

# For travel and any action that costs time
func advance_minutes(amount: int) -> void:
	for i in amount:
		if day_over or curfew_active:
			break
		_advance_minute()

# Called by CurfewHandler right after the teleport home
func jump_to_bedtime() -> void:
	hour = END_HOUR
	minute = 0
	_accumulator = 0.0
	day_over = true
	time_changed.emit(hour, minute)
	bedtime_reached.emit()

# Called by the bed
func start_next_day() -> void:
	day += 1
	hour = START_HOUR
	minute = 0
	_accumulator = 0.0
	curfew_active = false
	day_over = false
	paused = false
	day_started.emit(day)
	time_changed.emit(hour, minute)

func get_time_text() -> String:
	var h := hour % 12
	if h == 0:
		h = 12
	var suffix := "AM" if hour < 12 else "PM"
	return "%d:%02d %s" % [h, minute, suffix]

func get_save_data() -> Dictionary:
	return {"day": day, "hour": hour, "minute": minute}

func load_save_data(data: Dictionary) -> void:
	day = data.get("day", 1)
	hour = data.get("hour", START_HOUR)
	minute = data.get("minute", 0)
	curfew_active = hour >= CURFEW_HOUR
	day_over = hour >= END_HOUR
	_accumulator = 0.0
	time_changed.emit(hour, minute)
