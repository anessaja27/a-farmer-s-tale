# Village map setup (first map)

The project now starts in `res://Scenes/Maps/Village.tscn`.

## Scene structure

- `MapBase` — the supplied 960x768 Village x1 PNG, used as the visual base.
- `GroundPatches` — empty TileMapLayer with a 16x16 atlas from `assets/tilesets/Set 1.1.png`; use it to paint over parts of the baked map.
- `WorldYSort` — Y Sort Enabled; the existing player was moved here and starts at (480, 390).
- `CollisionObjects/MapObstacles` — StaticBody2D with approximate rectangle collisions for map boundaries, buildings, market stall, crop fence, and a few inner tree trunks.
- `Interactables` — reserved parent for Area2D interaction zones.
- `Foreground` — reserved layer for extracted tree canopies / roof fronts that should draw over the player.

## Important limitations

1. The village PNG is a flattened background. Godot cannot independently Y-sort the trees and houses that are baked into that single image. The player and other world objects can sort against each other, but the background art itself remains behind them. For correct behind/in-front behavior, move selected canopies or roof-front pieces into `Foreground` as separate sprites later.
2. Collision rectangles are an initial approximation based on the x1 image. Run the scene and adjust them in the editor if any area feels too large or too small. The top-left house has an opening in its collision so the existing `Door` Area2D can be reached.
3. The uploaded project contains a door interaction script and a bed interaction in the interior scene. It does not currently contain a general NPC/bench interaction handler. The supplied NPC and shop sprites have been copied into `assets/VillagePack/` for later integration; they are not auto-wired to dialogue yet.
4. `player_area.tscn` and the existing player/movement scripts were left in place. The new Village scene reuses the existing player node and its animations.

## Basic editing

- To cover an unwanted part of the PNG, paint a matching grass/path tile on `GroundPatches`.
- To place an NPC or object that should Y-sort with the player, add its scene as a child of `WorldYSort` and make sure its origin is near its feet/base.
- Add its physical blocker under `CollisionObjects` if it should stop the player.
- Add its interaction Area2D under `Interactables` and connect it to the project's interaction logic when that logic is implemented.
- Put separate canopy/roof-front sprites under `Foreground` when they must always draw in front of the player.
