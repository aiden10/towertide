extends Enemy

@onready var state_machine: Node = $StateMachine
@onready var aim_laser: Line2D = $AimLaser
var current_state: String

func _init() -> void:
	health = Enemies.SNIPER_HEALTH
	damage = Enemies.SNIPER_DAMAGE
	speed = Enemies.SNIPER_SPEED
	projectile_speed = Enemies.SNIPER_PROJECTILE_SPEED
	firerate_cooldown = Enemies.SNIPER_FIRERATE_COOLDOWN
	enemy_name = Enemies.SNIPER_ENEMY_NAME
	distance_threshold = randi_range(Enemies.SNIPER_MIN_DISTANCE_THRESHOLD, Enemies.SNIPER_MAX_DISTANCE_THRESHOLD)
	gold_drop_range = Enemies.SNIPER_GOLD_DROP_RANGE
	xp_drop_range = Enemies.SNIPER_XP_DROP_RANGE
	gold_drop_count = Enemies.SNIPER_GOLD_DROP_COUNT
	xp_drop_count = Enemies.SNIPER_XP_DROP_COUNT
	bullet_scale = Enemies.SNIPER_BULLET_SIZE
	spawn_radius = Enemies.SNIPER_SPAWN_RADIUS
	min_spawn_dist = Enemies.SNIPER_MIN_SPAWN_DIST
	item_drop_chance = Enemies.SNIPER_ITEM_DROP_CHANCE
	item_drop_count = Enemies.SNIPER_ITEM_DROP_COUNT

func _ready() -> void:
	state_machine.state_changed.connect(func(state_name): current_state = state_name)

func _process(_delta: float) -> void:
	if current_state == "attack":
		aim_laser.clear_points()
		aim_laser.visible = true
		aim_laser.add_point(Vector2.ZERO)
		aim_laser.add_point(to_local(GameState.player_position))
	else:
		aim_laser.visible = false
