extends Node

## Stats
var level: int = PlayerConstants.DEFAULT_LEVEL
var gold: int = PlayerConstants.DEFAULT_GOLD
var xp: int = PlayerConstants.DEFAULT_XP
var damage: float = PlayerConstants.DEFAULT_DAMAGE
var speed: float = PlayerConstants.DEFAULT_SPEED
var health: int = PlayerConstants.DEFAULT_HEALTH
var max_health: int = PlayerConstants.DEFAULT_MAX_HEALTH
var firerate: float = PlayerConstants.DEFAULT_FIRERATE
var projectile_speed: int = PlayerConstants.DEFAULT_PROJECTILE_SPEED
var knockback: float = PlayerConstants.DEFAULT_KNOCKBACK
var pierce: int = PlayerConstants.DEFAULT_PIERCE
var bullet_size: float = PlayerConstants.DEFAULT_BULLET_SIZE
var regen: int = PlayerConstants.DEFAULT_REGEN
var regen_cooldown: float = PlayerConstants.DEFAULT_REGEN_COOLDOWN
var sprayer_limit: int = PlayerConstants.DEFAULT_SPRAYER_LIMIT
var sentry_limit: int = PlayerConstants.DEFAULT_SENTRY_LIMIT
var blank_limit: int = PlayerConstants.DEFAULT_BLANK_LIMIT
var spawner_limit: int = PlayerConstants.DEFAULT_SPAWNER_LIMIT
var sprayer_count: int = 0
var sentry_count: int = 0
var spawner_count: int = 0
var blank_count: int = 0

## Misc
var minimum_gold: int = 0
var levels_available: int = PlayerConstants.DEFAULT_LEVELS_AVAILABLE
var player_items: Array[Item] = PlayerConstants.DEFAULT_PLAYER_ITEMS.duplicate()
var item_counts: Dictionary = PlayerConstants.DEFAULT_ITEM_COUNTS.duplicate()
var level_up_condition: int = PlayerConstants.DEFAULT_LEVEL_UP_CONDITION
var enemies_killed: int = PlayerConstants.DEFAULT_ENEMIES_KILLED
