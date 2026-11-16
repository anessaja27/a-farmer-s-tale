# Save / Load Menu

The pause menu now opens the Save and Load screens using the supplied pixel-art UI assets.

- Three save slots are stored under `user://save_slot_1.save` through `user://save_slot_3.save`.
- Saving to an occupied slot opens the overwrite confirmation scene.
- Loading restores the saved game clock, scene, and player world position.
- The Load screen also supports deleting a slot after confirmation.
- `SaveManager.save_game(slot)` returns `true` when a save was written successfully; `SaveManager.load_game(slot)` returns `true` when a load/scene transition was started successfully.

The current project only exposes persistent state through `TimeManager`, plus the player's scene and position. Add future systems (inventory, money, crop state, etc.) to `SAVEABLE_AUTOLOADS` and implement `get_save_data()` / `load_save_data()` on those systems to include them in saves.
