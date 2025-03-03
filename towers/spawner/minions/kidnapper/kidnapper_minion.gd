extends Minion

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	minion_name = Towers.KIDNAPPER_NAME
	damage = Towers.KIDNAPPER_DAMAGE
	speed = Towers.KIDNAPPER_SPEED
	min_wander = Towers.KIDNAPPER_MIN_WANDER
	firerate_cooldown = Towers.KIDNAPPER_COOLDOWN
	wander_distance = Towers.KIDNAPPER_WANDER_DIST
