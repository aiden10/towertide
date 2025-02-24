extends Node

signal pause_game
signal unpause_game

signal level_exited
signal level_cleared

signal gold_picked_up
signal xp_picked_up

signal arena_initialized
signal arena_spawn(child)

signal purchased
signal rerolled

signal level_up
signal add_item_scene(item_scene)

signal update_spawning_bar(time, enemies_to_spawn, time_scale)
signal extra_spawn

signal door_visible
signal door_not_visible

signal tower_selected
signal tower_deselected
signal tower_placed

signal tower1_selected
signal tower1_deselected
signal tower2_selected
signal tower2_deselected
signal tower3_selected
signal tower3_deselected
signal tower4_selected
signal tower4_deselected

signal minion_died
signal enemy_dead

signal player_hit
signal player_regenerated
signal enemy_hit
signal player_shot
signal enemy_shot
signal tower_shot
signal minion_spawned

signal deflect
signal sword_hit
signal sword_purchased

signal invalid_action
