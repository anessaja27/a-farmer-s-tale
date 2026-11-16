NEW GAME INTRO

The New Game button now opens new_game_intro.tscn before Village.tscn.
The intro is a black-screen, three-page text sequence with narration, gentle starter goals, and a controls reminder.

To edit the wording, open new_game_intro.gd and change the INTRO_PAGES array.
To edit layout, font, spacing, or colours, open new_game_intro.tscn.

The controls shown match the current project InputMap and player script:
- WASD: move
- Shift: run
- E: interact
- V or left mouse button: use the pickaxe

Continue still loads the newest valid save directly and does not show this intro.
The in-game clock is paused while the new-game intro is displayed, then resumes when the player enters the village.
