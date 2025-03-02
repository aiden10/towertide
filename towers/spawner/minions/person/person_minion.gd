extends Minion

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	minion_name = Towers.PERSON_NAME
	damage = Towers.PERSON_DAMAGE
	speed = Towers.PERSON_SPEED
	min_wander = Towers.PERSON_MIN_WANDER
	firerate_cooldown = Towers.PERSON_COOLDOWN
	wander_distance = Towers.PERSON_WANDER_DIST
	despawn_timer = Timer.new()
	despawn_timer.wait_time = Towers.PERSON_LIFETIME
	despawn_timer.one_shot = true
	despawn_timer.timeout.connect(_on_death)
	despawn_timer.autostart = true
	add_child(despawn_timer)
	sprite.play("default")
