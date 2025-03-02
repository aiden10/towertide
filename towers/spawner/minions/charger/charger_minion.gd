extends Minion

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	minion_name = Towers.CHARGER_NAME
	damage = Towers.CHARGER_DAMAGE
	speed = Towers.CHARGER_SPEED
	min_wander = Towers.CHARGER_MIN_WANDER
	wander_distance = Towers.CHARGER_WANDER_DIST
	despawn_timer = Timer.new()
	despawn_timer.wait_time = Towers.CHARGER_LIFETIME
	despawn_timer.one_shot = true
	despawn_timer.timeout.connect(_on_death)
	despawn_timer.autostart = true
	add_child(despawn_timer)
	sprite.play()
