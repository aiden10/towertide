extends Minion

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	minion_name = Towers.CHARGER_NAME
	damage = Towers.CHARGER_DAMAGE
	speed = Towers.CHARGER_SPEED
	min_wander = Towers.CHARGER_MIN_WANDER
	wander_distance = Towers.CHARGER_WANDER_DIST
	scale *= max(0.6, log(PlayerState.bullet_size))
	despawn_timer = Timer.new()
	add_child(despawn_timer)
	despawn_timer.wait_time = Towers.CHARGER_LIFETIME
	despawn_timer.one_shot = true
	despawn_timer.timeout.connect(_on_death)
	despawn_timer.autostart = true
	sprite.play()
