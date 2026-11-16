extends Control

const VILLAGE_SCENE: String = "res://Village.tscn"

# Edit these pages freely to rewrite the opening narration or tutorial.
const INTRO_PAGES: Array[Dictionary] = [
	{
		"heading": "A FRESH START",
		"body": "The city never seemed to slow down.\nAnd somewhere between the noise, the rush, and another long day, you started wishing for something simpler.\n\nSo you packed what you could, left the old routine behind, and came to a quiet village with a little patch of land waiting for you.\n\nIt is not much. Not yet. But it is a beginning."
	},
	{
		"heading": "YOUR FARM. YOUR STORY.",
		"body": "There is no grand checklist waiting for you. No need to build everything in a day.\n\nTake a walk around the village. Discover the places nearby. Get to know the people who call this place home. And, little by little, make this new life feel like yours.\n\nA FEW LITTLE GOALS\n- Explore the village and learn your way around.\n- Meet the neighbors and see what stories they have.\n- Take your time and make this place your own.\n\nNo rush, farmer. This tale belongs to you now."
	},
	{
		"heading": "BEFORE YOU BEGIN",
		"body": "A FEW THINGS TO KNOW\n\nWASD                  Move around\nSHIFT                  Hold to run\nE                         Interact with nearby things\nV / LEFT CLICK   Use your pickaxe\n\nTake a breath, look around, and enjoy the little things. You do not have to have it all figured out today.\n\nYour land is waiting. Your story starts now."
	}
]

@onready var heading_label: Label = $Center/Content/Heading
@onready var body_label: Label = $Center/Content/Body
@onready var page_label: Label = $Center/Content/PageLabel
@onready var next_button: Button = $Center/Content/Buttons/NextButton
@onready var skip_button: Button = $Center/Content/Buttons/SkipButton

var current_page: int = 0
var is_transitioning: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_show_page()
	next_button.grab_focus()


func _show_page() -> void:
	var page: Dictionary = INTRO_PAGES[current_page]
	heading_label.text = str(page.get("heading", "A FRESH START"))
	body_label.text = str(page.get("body", ""))
	page_label.text = "%02d  /  %02d" % [current_page + 1, INTRO_PAGES.size()]
	next_button.text = "LET'S BEGIN" if current_page == INTRO_PAGES.size() - 1 else "CONTINUE"
	skip_button.visible = current_page < INTRO_PAGES.size() - 1


func _on_next_button_pressed() -> void:
	if is_transitioning:
		return

	if current_page < INTRO_PAGES.size() - 1:
		current_page += 1
		_show_page()
		return

	_begin_game()


func _on_skip_button_pressed() -> void:
	_begin_game()


func _begin_game() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	TimeManager.paused = false
	next_button.disabled = true
	skip_button.disabled = true

	var change_error: Error = get_tree().change_scene_to_file(VILLAGE_SCENE)
	if change_error != OK:
		is_transitioning = false
		TimeManager.paused = true
		next_button.disabled = false
		skip_button.disabled = false
		push_error("Could not start the village scene: %s" % error_string(change_error))
