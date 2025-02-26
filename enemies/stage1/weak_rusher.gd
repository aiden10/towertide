extends Enemy

@onready var hurtbox: Area2D = $Hitbox

func _init() -> void:
	health = Enemies.WEAK_RUSHER_HEALTH
	damage = Enemies.WEAK_RUSHER_DAMAGE
	speed = randi_range(Enemies.WEAK_RUSHER_MIN_SPEED, Enemies.WEAK_RUSHER_MAX_SPEED)
	enemy_name = Enemies.WEAK_RUSHER_ENEMY_NAME
	gold_drop_range = Enemies.WEAK_RUSHER_GOLD_DROP_RANGE
	xp_drop_range = Enemies.WEAK_RUSHER_XP_DROP_RANGE
	gold_drop_count = Enemies.WEAK_RUSHER_GOLD_DROP_COUNT
	gold_drop_chance = Enemies.WEAK_RUSHER_GOLD_DROP_CHANCE
	xp_drop_count = Enemies.WEAK_RUSHER_XP_DROP_COUNT
	min_spawn_dist = Enemies.WEAK_RUSHER_MIN_SPAWN_DIST
	spawn_radius = Enemies.WEAK_RUSHER_SPAWN_RADIUS
	item_drop_count = 1

func _ready() -> void:
	hurtbox.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		Utils.spawn_hit_effect(Color(255, 0, 0, 50), position, damage)
		parent.take_damage(damage)
		queue_free()
