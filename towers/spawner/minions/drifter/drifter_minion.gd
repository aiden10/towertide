extends Minion

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	minion_name = Towers.DRIFTER_NAME
	damage = Towers.DRIFTER_DAMAGE
	speed = Towers.DRIFTER_SPEED
	min_wander = Towers.DRIFTER_MIN_WANDER
	projectile_speed = Towers.DRIFTER_PROJECTILE_SPEED
	firerate_cooldown = Towers.DRIFTER_COOLDOWN
	wander_distance = Towers.DRIFTER_WANDER_DIST
