extends Node

## Stats
var level: int = 1
var gold: int = 500
var xp: int = 1
var damage: int = 10
var speed: int = 300
var health: int = 100
var max_health: int = 100
var firerate: float = 0.5
var projectile_speed: int = 1000
var knockback: float = 100
var pierce: int = 1
var bullet_size: float = 0.01
var regen: int = 1
var regen_cooldown: int = 50

## Misc
var levels_available: int = 0
var player_items: Array = []
var level_up_condition: int = PlayerConstants.DEFAULT_LEVEL_UP_CONDITION
var enemies_killed: int = 0
var swords_added: int = 0
