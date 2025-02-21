extends Node

var level: int = 1
var gold: int = 0
var xp: int = 0
var arena: Node2D = null
var enemies_killed: int = 0
var clear_condition: int = 3
var player_items: Array = []
var damage: int = PlayerConstants.DEFAULT_DAMAGE
var speed: int = PlayerConstants.DEFAULT_PLAYER_SPEED
var health: int = PlayerConstants.STARTING_PLAYER_HEALTH
var max_hp: int = PlayerConstants.STARTING_PLAYER_HEALTH
var firerate: float = PlayerConstants.DEFAULT_FIRERATE
var projectile_speed: int = PlayerConstants.DEFAULT_PROJECTILE_SPEED
var level_up_condition: int = PlayerConstants.DEFAULT_LEVEL_UP_CONDITION
