extends Node

var player_projectiles: Dictionary = {}
var stage: int = GameConstants.DEFAULT_STAGE
var clear_condition: int = GameConstants.DEFAULT_CLEAR_CONDITION
var door_position: Vector2 = GameConstants.DEFAULT_DOOR_POSITION
var player_position: Vector2 = GameConstants.DEFAULT_PLAYER_POSITION
var selected_tower: Tower
var xp_count: int = GameConstants.DEFAULT_XP_COUNT
var gold_count: int = GameConstants.DEFAULT_GOLD_COUNT
var enemies_killed_this_stage: int = GameConstants.DEFAULT_ENEMIES_KILLED_THIS_STAGE
var allocate_menu_up: bool = GameConstants.DEFAULT_ALLOCATE_MENU_UP
var enemies_spawning: int = GameConstants.DEFAULT_ENEMIES_SPAWNING
var level_cleared: bool = GameConstants.DEFAULT_LEVEL_CLEARED

## Floor Max Values
const FLOOR_MAX_XP: int = GameConstants.FLOOR_MAX_XP
const FLOOR_MAX_GOLD: int = GameConstants.FLOOR_MAX_GOLD
