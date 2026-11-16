# Settings Menu

The settings screen is shared by the title screen and the in-game pause menu.

## Included options

- **Master volume:** Controls the Godot `Master` audio bus from 0% to 100%.
- **Fullscreen:** Switches between exclusive fullscreen and a 1280x720 window.
- **Defaults:** Restores 80% master volume and fullscreen mode.

Changes apply immediately and are stored in `user://settings.cfg`, so they persist after the game closes.

## Files

- `settings_menu.tscn` — settings screen layout.
- `settings_menu.gd` — settings behavior and persistence.
- `pause_menu.tscn` / `pause_menu.gd` — opens settings from the in-game pause menu.
- `main_menu.tscn` — opens the same settings screen from the title screen.

The project currently has no separate music or SFX audio buses / routed audio players, so this version exposes a master-volume control only.
