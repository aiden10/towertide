extends Minion

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	damage = Towers.CHARGER_DAMAGE
	speed = Towers.CHARGER_SPEED
	min_wander = Towers.CHARGER_MIN_WANDER
	wander_distance = Towers.CHARGER_WANDER_DIST
	sprite.play()
