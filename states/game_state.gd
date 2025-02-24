extends Node

var player_projectiles: Dictionary = {}
var stage: int = 1
var clear_condition: int = 3
var door_position: Vector2 = Vector2.ZERO
var player_position: Vector2
var selected_tower: Tower
var xp_count: int = 0
var gold_count: int = 0
var enemies_killed_this_stage: int = 0
var allocate_menu_up: bool = false
var enemies_spawning: int = 1
var level_cleared: bool = false
const FLOOR_MAX_XP: int = 80
const FLOOR_MAX_GOLD: int = 50
