extends Minion

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	minion_name = Towers.BUG_NAME
	damage = Towers.BUG_DAMAGE
	speed = Towers.BUG_SPEED
	min_wander = Towers.BUG_MIN_WANDER
	wander_distance = Towers.BUG_WANDER_DIST
	despawn_timer = Timer.new()
	despawn_timer.wait_time = Towers.BUG_LIFETIME
	despawn_timer.one_shot = true
	despawn_timer.timeout.connect(_on_death)
	despawn_timer.autostart = true
	add_child(despawn_timer)
