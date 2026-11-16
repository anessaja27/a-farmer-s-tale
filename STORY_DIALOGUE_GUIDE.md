# A Farmer's Tale — Story & Dialogue Guide

This project uses `story_manager.gd` as the single source of truth for the first chapter's dialogue and story flags.

## Chapter 1 schedule

- **Days 1–6:** The player meets the villagers while Cak Jon explains that the Plaza is under construction.
- **Day 7, 5:00 PM:** The Plaza unlocks permanently. The first Plaza visit triggers the reopening scene.
- **Day 14:** The first shared supper event plays on the next Plaza visit if it has not already played.
- **Day 21:** The seed-tin / passing-on-knowledge event plays on the next Plaza visit if it has not already played.
- **Day 30:** The finale plays on the next Plaza visit. Completing the final dialogue sets `story_completed`.
- **After the finale:** The game continues in free-play. NPCs use post-story daily lines and repeat-visit variations; no further main-story scenes play.

If the player misses a milestone event, overdue events before Day 30 play in chronological order on later Plaza visits. If the player first enters the Plaza on Day 30 or later, the finale takes priority and earlier milestone flags are marked complete.

## NPC dialogue editing

Open `story_manager.gd` and edit `NPC_DIALOGUES`.

- The `edi`, `joko`, `shophy`, and `cak_jon` lists each contain 30 entries.
- Entry 1 is Day 1, entry 2 is Day 2, and so on through Day 30.
- Keep each line short (usually 1–3 sentences) so it fits in the dialogue panel.
- `REPEAT_DIALOGUES` contains short alternate lines used when the player talks to the same NPC again on the same day.
- `POST_STORY_DIALOGUES` contains the ordinary daily dialogue used after the Day 30 finale.

The player remains silent. NPCs speak through the shared dialogue panel; narrator lines use a black screen.

## Where the system is connected

- `Edi.tscn`, `joko.tscn`, `shophy.tscn`, and `Cak Jon.tscn` call `StoryManager.interact_with_npc(...)`.
- `door.gd` checks the Plaza entrance before scene travel and asks Cak Jon's gate dialogue while locked.
- `StoryManager` is registered as an autoload in `project.godot`.
- `save_manager.gd` saves StoryManager state with each save slot, including Plaza unlock, story completion, milestone events, and that day's NPC interaction counts.

## Save compatibility

The save format version is now 3. Existing saves without a StoryManager section are still loadable. Their story flags are initialized from the saved in-game day, so a save already beyond Day 7 will not permanently lock the Plaza.

## Testing checklist

1. Start a fresh game and confirm Cak Jon blocks the Plaza before Day 7 at 5:00 PM.
2. Speak to each NPC twice on one day: first line should be that day's line, second should be a short variation.
3. Advance to Day 7 at 5:00 PM and enter the Plaza; the reopening event should play once.
4. Enter the Plaza on/after Days 14 and 21; each milestone event should play once.
5. Enter the Plaza on/after Day 30; finish the finale and confirm the game remains playable.
6. Save and reload before and after the Plaza unlock and after the finale; story progression should persist.
