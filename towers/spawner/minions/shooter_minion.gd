extends Minion

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	minion_name = Towers.SHOOTER_NAME
	damage = Towers.SHOOTER_DAMAGE
	speed = Towers.SHOOTER_SPEED
	min_wander = Towers.SHOOTER_MIN_WANDER
	wander_distance = Towers.SHOOTER_WANDER_DIST
	firerate_cooldown = Towers.SHOOTER_COOLDOWN * PlayerState.firerate
	projectile_speed = Towers.SHOOTER_PROJECTILE_SPEED
	bullet_scale = Towers.SHOOTER_BULLET_SCALE
	scale *= max(0.25, log(PlayerState.bullet_size))
