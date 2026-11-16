extends Node

signal story_state_changed

const STORY_LENGTH: int = 30
const PLAZA_UNLOCK_DAY: int = 7
const PLAZA_UNLOCK_HOUR: int = 17

const NPC_NAMES: Dictionary = {
	"edi": "Edi",
	"joko": "Joko",
	"shophy": "Shophy",
	"cak_jon": "Cak Jon",
}

# One short, day-specific line per NPC. Keep each list at 30 entries.
const NPC_DIALOGUES: Dictionary = {
	"edi": [
		"You're the one who moved into the old farmhouse, right? Welcome. It's been quiet around here for quite some time.",
		"Settling in alright? No need to fix everything in one day. Even an old house needs time.",
		"See that noticeboard near the square? I keep meaning to repair it. Nobody really uses it anymore.",
		"I checked behind the loose board today. Found an old note tucked inside. Someone wanted it kept safe.",
		"Joko says the note is from his wife. Maybe we should find a way to bring that old promise back.",
		"I found some good timber in the shed. The noticeboard might finally get the repair it deserves.",
		"The Plaza opens this evening. I even managed to fix the noticeboard. Not bad for a week's work.",
		"Seeing people in the Plaza again was nice. I forgot how much sound a quiet place could hold.",
		"I'm thinking of adding a small message section to the board. Lost things, spare seeds, that sort of thing.",
		"A village works better when people share what they know. We should make that easier.",
		"Shophy asked me to look at a shelf in her shop. Apparently it has been leaning for a month.",
		"I fixed the shelf. Shophy called it a miracle. It was two nails and a bit of patience.",
		"The old board has more notes now. Funny how quickly people remember how to use it.",
		"Tomorrow, let's put a table in the Plaza. Joko has a few old recipes he wants to share.",
		"That little supper went well. Nobody cared what the food looked like. They just wanted to sit together.",
		"I used to think a village needed big plans to change. Turns out a table and a few chairs can do plenty.",
		"The board is getting crowded. I might need a second one. That's a good problem to have.",
		"Joko stopped by to tell me another story. He seemed lighter today. I'm glad.",
		"Shophy wants to put a handwritten menu outside her shop. I told her people can already read the sign.",
		"She put the menu up anyway. It does look better, I'll give her that.",
		"Cak Jon asked if I could help organize a small gathering next week. I said yes before he finished asking.",
		"The Plaza has become a proper meeting place again. People are making plans without being asked.",
		"I found an old photograph while clearing a cupboard. Everyone looked so young. Even Joko had hair.",
		"I think we should keep a place on the board for village memories. They deserve somewhere to stay.",
		"The festival decorations are coming together. I never thought I'd enjoy tying ribbons to a fence.",
		"A few neighbors came by to help today. Nobody made a big deal of it. They just brought what they could.",
		"The Plaza is looking good. I hope we remember to keep it that way after the celebration.",
		"I've been thinking about how quiet this place used to feel. It doesn't seem so quiet now.",
		"Joko says the village sounds like it used to. I think that's the nicest thing anyone could say.",
		"Tomorrow's gathering should be a good one. The important part is that everyone has a place at the table.",
	],
	"joko": [
		"Ah, a new face. We don't get many of those anymore. I hope this little village treats you kindly.",
		"When I was young, people greeted each other before the sun got too high. Some habits are worth keeping.",
		"That noticeboard used to be full of announcements. Weddings, market days, harvest gatherings... good times.",
		"Let me see that handwriting... I remember it. My wife wrote notes like that whenever she had an idea.",
		"She always wanted the neighbors to eat together after harvest. Said food tasted better when it was shared.",
		"I still have one of her old recipes. The paper is worn, but I know every word by heart.",
		"I think she'd have liked seeing the Plaza open again. She never enjoyed an empty gathering place.",
		"Thank you for yesterday. I haven't heard that much laughter in the Plaza for a long time.",
		"I used to sit by the fountain after market days. It was the best place to hear everyone's news.",
		"My wife could remember everyone's birthday. I struggle to remember where I left my glasses.",
		"I found a little tin of old photographs. Perhaps I'll bring them out when people have time to look.",
		"There I am, standing beside a harvest basket twice my size. I was very proud of that basket.",
		"Memories are funny. You think you've forgotten them, then one small thing brings them all back.",
		"I've been asked to bring a recipe to tomorrow's supper. I know exactly which one she'll want me to make.",
		"The meal reminded me of our old harvest evenings. Different faces, same warm feeling.",
		"I used to think the best days were already behind me. Perhaps there are still a few ahead.",
		"Shophy asked about the photograph of my wife. I told her the story. She listened to every word.",
		"She laughed at one of my old stories today. My wife would have liked that girl.",
		"The village is finding its rhythm again. I can hear it in the morning greetings.",
		"I wrote down another recipe before I forgot it. My handwriting is getting worse, but the taste should be fine.",
		"Cak Jon says he wants to teach someone the old ways of tending the soil. I hope he does.",
		"I told Cak Jon about the first field I ever planted. Half the crop failed. We ate the other half together.",
		"I found a letter I wrote to my wife years ago. I never gave it to her. Funny what we keep.",
		"I think I'll put that letter beside her recipe. Some things belong together, even after all this time.",
		"The Plaza is getting ready for a celebration. My wife would have insisted on bringing too much food.",
		"I made a little extra today. Old habits, I suppose. Someone will always be hungry.",
		"I don't feel quite so alone when the village is busy. I should have let people in sooner.",
		"The noticeboard has a note from someone thanking their neighbor. That would have made my wife smile.",
		"A month ago, this village felt like a collection of quiet houses. Now it feels like people again.",
		"Whatever happens after tomorrow, promise me you'll keep making memories here. They are worth more than you think.",
	],
	"shophy": [
		"Hey! You're the new farmer! I'm Shophy. Come by my shop whenever you need something. Or just want a chat!",
		"You're back! First rule of village life: always say hello. Unless the other person is sleeping.",
		"Someone bought three bags of flour yesterday. Three! I wonder what they're baking.",
		"That old noticeboard? Edi keeps promising to fix it. He's been promising for months. Don't tell him I said that.",
		"I heard Joko found an old note from his wife. I hope he tells me the story. I promise not to interrupt. Much.",
		"I'm thinking of making something for the Plaza opening. Don't ask what. I'm still negotiating with the oven.",
		"It's opening day! I brought snacks. If nobody eats them, I'll have to do it myself. Terrible problem.",
		"Yesterday was lovely. I sold almost nothing, but everyone stayed to talk. That's a different kind of good day.",
		"I want to make my shop feel a little more welcoming. Maybe a flower pot by the door? Maybe three.",
		"Edi fixed the shelf. I told him it looked easy. He said I should try it next time. Rude, but fair.",
		"I made a new sign for the shop. It took all morning because I kept changing the letters.",
		"The new sign is up! People can finally tell where the shop is. I should have done that sooner.",
		"A customer asked if I could stock more local things. I think that's a rather good idea.",
		"I'm bringing bread to the Plaza tomorrow. If it comes out lopsided, just call it rustic.",
		"Everyone loved the bread! Even the lopsided ones disappeared. I may have found my specialty.",
		"I used to think my shop was too small to matter. But people keep stopping by, and that counts for something.",
		"Joko showed me an old photograph today. He had a very serious haircut. I tried not to laugh.",
		"I asked Joko about his wife. He told me she used to make the whole village feel welcome. I'd like to do that too.",
		"I want to save up and make the shop a little bigger someday. One shelf at a time, I suppose.",
		"I put a jar of flowers on the counter. People keep complimenting it. Perhaps I should open a flower shop.",
		"Cak Jon says the village should have another gathering. I said yes before he mentioned the work involved.",
		"I've started a list of things the shop could offer. It's getting long. My shelves are getting nervous.",
		"I sold a small basket to someone who said it was for their neighbor. That's the sort of business I like.",
		"The shop feels different lately. Not bigger, exactly. Just busier in the nicest way.",
		"I'm making decorations for the Plaza. There may be too many ribbons. There is no such thing as too many ribbons.",
		"I think I finally found a recipe worth keeping. I'll write it down before I forget the secret ingredient.",
		"The village has been helping with everything. I want to do something nice for everyone in return.",
		"I put a little thank-you note in the shop window. Someone left one back. I may have teared up. A little.",
		"A whole month already! I feel like I know everyone's usual order. That's either wonderful or worrying.",
		"Tomorrow, bring an appetite. I've been preparing something special, and I'm not accepting tiny portions as an excuse.",
	],
	"cak_jon": [
		"Whoa, careful there, farmer. The Plaza's closed for repairs. We've got loose boards and tools all over the place.",
		"Still a mess inside. We're fixing the walking paths first. Give us a little time.",
		"The fountain's looking better, but those benches need some work. One thing at a time.",
		"Edi says he'll help with the noticeboard. Shophy's already talking about decorations. Those two get carried away.",
		"We're making progress. Not fast, but steady. That's how you do most things around here.",
		"Almost there, farmer. Come back tomorrow evening. This place could use a little life again.",
		"Well, look at that. The Plaza is ready. Come back after five this evening and take a look around.",
		"Not bad for a reopening, eh? I haven't seen people gather like that in years.",
		"The soil near the river holds water longer. Could be useful if you ever decide to grow something there.",
		"A good farmer watches the weather, but also watches the people around them. Both can surprise you.",
		"My back's been complaining lately. I told it to take the day off. It didn't listen.",
		"I used to work these fields from sunrise to supper. These days I know when to take a break. Mostly.",
		"Joko remembers every harvest supper. I remember who burnt the first batch of potatoes. Never forget.",
		"Tomorrow's meal should be simple. Good food, a few chairs, and nobody asking me to give a speech.",
		"That was a fine supper. I ate more than I planned. Don't tell anyone I went back for seconds.",
		"Farming can be lonely work. That's why it's good to have somewhere to go when the day's done.",
		"I found my old seed tin today. It's dented, but still useful. Some things last if you look after them.",
		"The younger folks asked me how I started farming. I told them the truth: by making plenty of mistakes.",
		"I might teach a little more often. No point keeping every trick to myself.",
		"There's a difference between doing everything alone and being independent. Took me years to learn it.",
		"I want to organize a small day for sharing tools and advice. Everyone has something worth passing on.",
		"A farmer's best tool isn't always a shovel. Sometimes it's the neighbor who shows up when you need help.",
		"Joko gave me an old photograph today. I looked younger than I remember. Funny how that works.",
		"We should leave a record of what this village was like. The next lot might want to know.",
		"The Plaza needs a proper celebration. I can help set things up, but somebody else is carrying the tables.",
		"I brought vegetables for the gathering. They're not pretty, but they'll taste good. That's what matters.",
		"Everyone's been pitching in. Makes a man feel like his work still matters.",
		"I think I'll keep the seed tin on the shelf where people can see it. Maybe someone will ask about it.",
		"A month ago, I was guarding a closed Plaza. Now I'm helping plan a celebration. That's a nice change.",
		"You've done well, farmer. Keep looking after your land, and don't forget to look after yourself too.",
	],
}

const REPEAT_DIALOGUES: Dictionary = {
	"edi": [
		"Everything alright? Give it time. Good work is rarely rushed.",
		"If you need a hand, ask. No need to make every little thing difficult.",
		"I'll be around. There's always something that needs fixing.",
	],
	"joko": [
		"Take your time, young one. The day is still yours.",
		"Ah, back again? It's nice to have someone to talk to.",
		"I was just remembering something. Perhaps I'll tell you another day.",
	],
	"shophy": [
		"Back already? I like a familiar face!",
		"Don't mind me. I'm just keeping the shop and the gossip in order.",
		"Come by later. I might have something new to tell you.",
	],
	"cak_jon": [
		"Keep your eyes open and your shoulders loose. That's my advice for today.",
		"Still around, farmer? Good. The village could use the company.",
		"I'll be here if you need a bit of advice.",
	],
}

const POST_STORY_DIALOGUES: Dictionary = {
	"edi": [
		"The noticeboard is still getting used. I might have to build another one.",
		"Quiet day today. A good chance to catch up on a few repairs.",
		"People have started leaving notes for one another. I'm glad we kept the board.",
		"The village feels lived in again. That's all I ever wanted for this place.",
	],
	"joko": [
		"Beautiful evening, isn't it? Makes an old man want to sit by the fountain.",
		"I wrote down another memory today. I don't want the little things to disappear.",
		"I still make too much food. Some habits are hard to change.",
		"Come sit a while sometime. There's always another story to tell.",
	],
	"shophy": [
		"Hey! Don't forget to visit the shop tomorrow. I might have something new!",
		"Business is good, and the village is busy. I think I'll keep this little shop just as it is for now.",
		"I put fresh flowers by the counter. People seem to like them. So do I.",
		"A quiet day at the shop? I'll take it. Even gossip needs a day off.",
	],
	"cak_jon": [
		"Still working on that farm? Good. There's always something to do.",
		"Remember to rest, farmer. Soil can wait. Your back might not.",
		"If you ever need advice, you know where to find me.",
		"The Plaza's open, the village is lively, and the fields are waiting. Not a bad life, eh?",
	],
}

const PLAZA_GATE_DIALOGUES: Array[String] = [
	"Whoa, careful there, farmer. The Plaza's closed for repairs. We've got loose boards and tools all over the place.",
	"Still a mess inside. We're fixing the walking paths first. Give us a little time.",
	"The fountain's looking better, but those benches need some work. One thing at a time.",
	"Edi says he'll help with the noticeboard. Shophy's already talking about decorations. Those two get carried away.",
	"We're making progress. Not fast, but steady. That's how you do most things around here.",
	"Almost there, farmer. Come back tomorrow evening. This place could use a little life again.",
]

const DAY_7_PLAZA_EVENT: Array[Dictionary] = [
	{"speaker": "Narrator", "text": "By early evening, the last tools are put away. The old Plaza is ready to welcome people again.", "narrator": true},
	{"speaker": "Cak Jon", "text": "Well, look at that. Not a loose board in sight. Come on in, farmer. This place is open again."},
	{"speaker": "Edi", "text": "It's not perfect, but it's ours. That's a good place to start."},
	{"speaker": "Shophy", "text": "I brought snacks! And yes, I brought enough for everyone. Probably."},
	{"speaker": "Joko", "text": "I think this is the first time in years that the Plaza has felt like the heart of the village again."},
]

const DAY_14_PLAZA_EVENT: Array[Dictionary] = [
	{"speaker": "Narrator", "text": "A week after the reopening, a few tables appear beside the fountain. Nobody made a formal plan. People simply brought what they had.", "narrator": true},
	{"speaker": "Joko", "text": "This is how our old harvest suppers began. One dish, one neighbor, and a reason to stay a little longer."},
	{"speaker": "Shophy", "text": "I brought bread. Some pieces are a bit uneven, but that's how you know they're homemade."},
	{"speaker": "Edi", "text": "No speeches tonight. Just eat, talk, and enjoy the evening."},
]

const DAY_21_PLAZA_EVENT: Array[Dictionary] = [
	{"speaker": "Narrator", "text": "The village has found a new rhythm. This evening, Cak Jon brings an old seed tin to the Plaza and sets it on the table.", "narrator": true},
	{"speaker": "Cak Jon", "text": "I've kept this tin for years. It holds more mistakes than seeds, but every one taught me something."},
	{"speaker": "Joko", "text": "Then let the next generation learn from both. That's how a village keeps growing."},
	{"speaker": "Cak Jon", "text": "That's the plan. There's plenty I can still teach, and plenty I still need to learn."},
]

const DAY_30_FINALE: Array[Dictionary] = [
	{"speaker": "Narrator", "text": "Thirty days ago, you arrived here as a stranger. You found an empty field, unfamiliar faces, and a village that had almost forgotten what it meant to come together.", "narrator": true},
	{"speaker": "Narrator", "text": "But somewhere between the greetings, old stories, shared meals, and little promises, something began to change.", "narrator": true},
	{"speaker": "Edi", "text": "Never thought we'd see this place filled with people again. Guess we just needed a reason to come together."},
	{"speaker": "Shophy", "text": "Look at everyone! I haven't seen this many people together in years. I'm going to remember this one."},
	{"speaker": "Joko", "text": "When I first saw you arrive, I thought you'd just be passing through. I'm glad this place gave you a reason to stay."},
	{"speaker": "Cak Jon", "text": "Well, farmer. Looks like you've found yourself a home. Keep looking after it."},
	{"speaker": "Narrator", "text": "The fields are still waiting to be tended. The shop will open tomorrow. And the people here still have plenty of stories to share.", "narrator": true},
	{"speaker": "Narrator", "text": "Your story has found its place. But your days here are far from over.", "narrator": true},
]

var plaza_unlocked: bool = false
var story_completed: bool = false
var plaza_opening_seen: bool = false
var day_14_event_seen: bool = false
var day_21_event_seen: bool = false

var _interaction_day: int = 1
var _interaction_counts: Dictionary = {}
var _dialogue_lines: Array[Dictionary] = []
var _dialogue_index: int = 0
var _dialogue_open: bool = false
var _dialogue_is_finale: bool = false
var _was_paused: bool = false

var _canvas: CanvasLayer
var _ui_root: Control
var _black_overlay: ColorRect
var _dialogue_panel: PanelContainer
var _speaker_label: Label
var _body_label: Label
var _continue_label: Label
var _narration_center: CenterContainer
var _narration_label: Label
var _narration_hint: Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_interaction_day = TimeManager.day
	_build_dialogue_ui()
	if not TimeManager.time_changed.is_connected(_on_time_changed):
		TimeManager.time_changed.connect(_on_time_changed)
	if not TimeManager.day_started.is_connected(_on_day_started):
		TimeManager.day_started.connect(_on_day_started)
	if not get_tree().scene_changed.is_connected(_on_scene_changed):
		get_tree().scene_changed.connect(_on_scene_changed)
	_refresh_plaza_unlock()


func start_new_story() -> void:
	plaza_unlocked = false
	story_completed = false
	plaza_opening_seen = false
	day_14_event_seen = false
	day_21_event_seen = false
	_interaction_day = 1
	_interaction_counts.clear()
	_dialogue_lines.clear()
	_dialogue_index = 0
	_dialogue_open = false
	_dialogue_is_finale = false
	if _ui_root != null:
		_ui_root.hide()
	_refresh_plaza_unlock()
	story_state_changed.emit()


func is_plaza_unlocked() -> bool:
	_refresh_plaza_unlock()
	return plaza_unlocked


func _refresh_plaza_unlock() -> void:
	if plaza_unlocked:
		return
	if TimeManager.day > PLAZA_UNLOCK_DAY:
		plaza_unlocked = true
	elif TimeManager.day == PLAZA_UNLOCK_DAY and TimeManager.hour >= PLAZA_UNLOCK_HOUR:
		plaza_unlocked = true
	if plaza_unlocked:
		story_state_changed.emit()


func _on_time_changed(_hour: int, _minute: int) -> void:
	_refresh_plaza_unlock()


func _on_day_started(day: int) -> void:
	if day != _interaction_day:
		_interaction_day = day
		_interaction_counts.clear()
	_refresh_plaza_unlock()


func interact_with_npc(npc_id: String, fallback_name: String = "Villager") -> void:
	if _dialogue_open or not NPC_DIALOGUES.has(npc_id):
		return
	if _interaction_day != TimeManager.day:
		_interaction_day = TimeManager.day
		_interaction_counts.clear()

	var count: int = int(_interaction_counts.get(npc_id, 0))
	var speaker: String = str(NPC_NAMES.get(npc_id, fallback_name))
	var dialogue_text: String = ""
	if story_completed and count == 0:
		var post_lines: Array = POST_STORY_DIALOGUES.get(npc_id, [])
		if post_lines.is_empty():
			dialogue_text = "It's a lovely day in the village, isn't it?"
		else:
			var post_index: int = posmod(maxi(TimeManager.day - STORY_LENGTH, 0), post_lines.size())
			dialogue_text = str(post_lines[post_index])
	elif count > 0:
		dialogue_text = _get_repeat_dialogue_text(npc_id, count)
	else:
		var daily_lines: Array = NPC_DIALOGUES.get(npc_id, [])
		if daily_lines.is_empty():
			dialogue_text = "It's a peaceful day in the village."
		else:
			var day_index: int = clampi(TimeManager.day - 1, 0, daily_lines.size() - 1)
			dialogue_text = str(daily_lines[day_index])

	_interaction_counts[npc_id] = count + 1
	_open_dialogue([{"speaker": speaker, "text": dialogue_text}], false)


func _get_repeat_dialogue_text(npc_id: String, interaction_count: int) -> String:
	var repeat_lines: Array = REPEAT_DIALOGUES.get(npc_id, [])
	if repeat_lines.is_empty():
		return "Good to see you again."
	var repeat_index: int = posmod(maxi(interaction_count - 1, 0), repeat_lines.size())
	return str(repeat_lines[repeat_index])


func show_plaza_gate_dialogue() -> void:
	if _dialogue_open or is_plaza_unlocked():
		return
	var line_index: int = clampi(TimeManager.day - 1, 0, PLAZA_GATE_DIALOGUES.size() - 1)
	var gate_line: String = PLAZA_GATE_DIALOGUES[line_index]
	if TimeManager.day >= PLAZA_UNLOCK_DAY:
		gate_line = "Almost there, farmer. The Plaza opens at 5:00 PM. Come back when the clock gets there."
	_open_dialogue([{"speaker": "Cak Jon", "text": gate_line}], false)


func _on_scene_changed() -> void:
	var new_scene: Node = get_tree().current_scene
	if new_scene == null:
		return
	if new_scene.scene_file_path.get_file().to_lower() != "plaza.tscn":
		return
	call_deferred("_start_plaza_story_event_if_due")


func _start_plaza_story_event_if_due() -> void:
	if _dialogue_open or story_completed:
		return
	if TimeManager.day >= STORY_LENGTH:
		plaza_opening_seen = true
		day_14_event_seen = true
		day_21_event_seen = true
		_open_dialogue(DAY_30_FINALE, true)
	elif TimeManager.day >= PLAZA_UNLOCK_DAY and not plaza_opening_seen:
		plaza_opening_seen = true
		_open_dialogue(DAY_7_PLAZA_EVENT, false)
	elif TimeManager.day >= 14 and not day_14_event_seen:
		day_14_event_seen = true
		_open_dialogue(DAY_14_PLAZA_EVENT, false)
	elif TimeManager.day >= 21 and not day_21_event_seen:
		day_21_event_seen = true
		_open_dialogue(DAY_21_PLAZA_EVENT, false)


func _build_dialogue_ui() -> void:
	_canvas = CanvasLayer.new()
	_canvas.name = "StoryDialogueLayer"
	_canvas.layer = 80
	add_child(_canvas)

	_ui_root = Control.new()
	_ui_root.name = "DialogueRoot"
	_ui_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_ui_root.mouse_filter = Control.MOUSE_FILTER_STOP
	_ui_root.hide()
	_canvas.add_child(_ui_root)

	_black_overlay = ColorRect.new()
	_black_overlay.color = Color.BLACK
	_black_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_black_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_black_overlay.hide()
	_ui_root.add_child(_black_overlay)

	_narration_center = CenterContainer.new()
	_narration_center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_narration_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_narration_center.hide()
	_ui_root.add_child(_narration_center)

	var narration_box: VBoxContainer = VBoxContainer.new()
	narration_box.custom_minimum_size = Vector2(1050, 360)
	narration_box.alignment = BoxContainer.ALIGNMENT_CENTER
	narration_box.add_theme_constant_override("separation", 28)
	_narration_center.add_child(narration_box)

	_narration_label = Label.new()
	_narration_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_narration_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_narration_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_narration_label.add_theme_font_size_override("font_size", 27)
	_narration_label.add_theme_color_override("font_color", Color("#eee4d0"))
	narration_box.add_child(_narration_label)

	_narration_hint = Label.new()
	_narration_hint.text = "E / ENTER  —  CONTINUE"
	_narration_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_narration_hint.add_theme_font_size_override("font_size", 16)
	_narration_hint.add_theme_color_override("font_color", Color("#9c927e"))
	narration_box.add_child(_narration_hint)

	_dialogue_panel = PanelContainer.new()
	_dialogue_panel.name = "DialoguePanel"
	_dialogue_panel.anchor_left = 0.055
	_dialogue_panel.anchor_top = 0.715
	_dialogue_panel.anchor_right = 0.945
	_dialogue_panel.anchor_bottom = 0.965
	_dialogue_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_dialogue_panel.custom_minimum_size = Vector2(0, 190)
	var panel_style: StyleBoxFlat = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.075, 0.065, 0.05, 0.97)
	panel_style.border_color = Color("#c99b60")
	panel_style.set_border_width_all(3)
	panel_style.set_corner_radius_all(10)
	panel_style.content_margin_left = 28.0
	panel_style.content_margin_right = 28.0
	panel_style.content_margin_top = 18.0
	panel_style.content_margin_bottom = 16.0
	_dialogue_panel.add_theme_stylebox_override("panel", panel_style)
	_ui_root.add_child(_dialogue_panel)

	var content: VBoxContainer = VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	_dialogue_panel.add_child(content)

	_speaker_label = Label.new()
	_speaker_label.add_theme_font_size_override("font_size", 23)
	_speaker_label.add_theme_color_override("font_color", Color("#e9c58f"))
	content.add_child(_speaker_label)

	_body_label = Label.new()
	_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_body_label.add_theme_font_size_override("font_size", 20)
	_body_label.add_theme_color_override("font_color", Color("#f1eee6"))
	_body_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(_body_label)

	_continue_label = Label.new()
	_continue_label.text = "E / ENTER  —  CONTINUE"
	_continue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_continue_label.add_theme_font_size_override("font_size", 14)
	_continue_label.add_theme_color_override("font_color", Color("#a79b85"))
	content.add_child(_continue_label)


func _open_dialogue(lines: Array, is_finale: bool) -> void:
	if _dialogue_open or lines.is_empty():
		return
	_dialogue_lines.clear()
	for line: Variant in lines:
		if line is Dictionary:
			_dialogue_lines.append(line.duplicate(true))
	if _dialogue_lines.is_empty():
		return

	_dialogue_index = 0
	_dialogue_open = true
	_dialogue_is_finale = is_finale
	_was_paused = get_tree().paused
	get_tree().paused = true
	_ui_root.show()
	_display_dialogue_line()


func _display_dialogue_line() -> void:
	if _dialogue_index < 0 or _dialogue_index >= _dialogue_lines.size():
		return
	var line: Dictionary = _dialogue_lines[_dialogue_index]
	var is_narrator: bool = bool(line.get("narrator", false))
	var text_value: String = str(line.get("text", ""))
	if is_narrator:
		_black_overlay.show()
		_narration_center.show()
		_dialogue_panel.hide()
		_narration_label.text = text_value
		_narration_hint.text = "E / ENTER  —  CONTINUE" if _dialogue_index < _dialogue_lines.size() - 1 else "E / ENTER  —  FINISH"
	else:
		_black_overlay.hide()
		_narration_center.hide()
		_dialogue_panel.show()
		_speaker_label.text = str(line.get("speaker", "Villager"))
		_body_label.text = text_value
		_continue_label.text = "E / ENTER  —  CONTINUE" if _dialogue_index < _dialogue_lines.size() - 1 else "E / ENTER  —  CLOSE"


func _input(event: InputEvent) -> void:
	if not _dialogue_open:
		return
	if event is InputEventKey and event.echo:
		return
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		_advance_dialogue()


func _advance_dialogue() -> void:
	if not _dialogue_open:
		return
	if _dialogue_index < _dialogue_lines.size() - 1:
		_dialogue_index += 1
		_display_dialogue_line()
	else:
		_close_dialogue()


func _close_dialogue() -> void:
	_dialogue_open = false
	_ui_root.hide()
	_black_overlay.hide()
	_narration_center.hide()
	_dialogue_panel.hide()
	if _dialogue_is_finale:
		story_completed = true
		story_state_changed.emit()
	_dialogue_is_finale = false
	_dialogue_lines.clear()
	get_tree().paused = _was_paused


func get_save_data() -> Dictionary:
	return {
		"version": 1,
		"plaza_unlocked": plaza_unlocked,
		"story_completed": story_completed,
		"plaza_opening_seen": plaza_opening_seen,
		"day_14_event_seen": day_14_event_seen,
		"day_21_event_seen": day_21_event_seen,
		"interaction_day": _interaction_day,
		"interaction_counts": _interaction_counts.duplicate(true),
	}


func load_save_data(data: Dictionary) -> void:
	plaza_unlocked = bool(data.get("plaza_unlocked", false))
	story_completed = bool(data.get("story_completed", false))
	plaza_opening_seen = bool(data.get("plaza_opening_seen", false))
	day_14_event_seen = bool(data.get("day_14_event_seen", false))
	day_21_event_seen = bool(data.get("day_21_event_seen", false))
	_interaction_day = int(data.get("interaction_day", TimeManager.day))
	var counts_value: Variant = data.get("interaction_counts", {})
	if counts_value is Dictionary:
		_interaction_counts = counts_value.duplicate(true)
	else:
		_interaction_counts = {}
	if _interaction_day != TimeManager.day:
		_interaction_day = TimeManager.day
		_interaction_counts.clear()
	_refresh_plaza_unlock()
	story_state_changed.emit()
