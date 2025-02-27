extends Node

var player_projectiles: Dictionary = {}
var stage: int = GameConstants.DEFAULT_STAGE
var clear_condition: int = GameConstants.DEFAULT_CLEAR_CONDITION
var door_position: Vector2 = GameConstants.DEFAULT_DOOR_POSITION
var player_position: Vector2 = GameConstants.DEFAULT_PLAYER_POSITION
var selected_tower: Tower
var enemies_killed_this_stage: int = GameConstants.DEFAULT_ENEMIES_KILLED_THIS_STAGE
var enemies_spawning: int = GameConstants.DEFAULT_ENEMIES_SPAWNING
var level_cleared: bool = GameConstants.DEFAULT_LEVEL_CLEARED
var boss_stage_increment: int = GameConstants.DEFAULT_BOSS_STAGE_INCREMENT
var tower_type: int = 0
var enemy_counts: Dictionary = {}
var allocate_menu_up: bool = false
var is_boss_stage: bool = false
var placing_tower: bool = false
var valid_placement: bool = false
var wave_started: bool = false
var boss_dead: bool = false
