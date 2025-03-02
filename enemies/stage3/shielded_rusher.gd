extends Enemy

@onready var shield1: Node2D = $Shield1
@onready var hurtbox: Area2D = $Hitbox
var rotation_radius: float = 50
var original_shield_position1: Vector2

func _ready() -> void:
	hurtbox.area_entered.connect(_on_area_entered)
	original_shield_position1 = shield1.position
	
func _init() -> void:
	health = Enemies.SHIELDED_RUSHER_HEALTH
	damage = Enemies.SHIELDED_RUSHER_DAMAGE
	speed = randi_range(Enemies.SHIELDED_RUSHER_MIN_SPEED, Enemies.SHIELDED_RUSHER_MAX_SPEED)
	enemy_name = Enemies.SHIELDED_RUSHER_ENEMY_NAME
	gold_drop_range = Enemies.SHIELDED_RUSHER_GOLD_DROP_RANGE
	xp_drop_range = Enemies.SHIELDED_RUSHER_XP_DROP_RANGE
	gold_drop_count = Enemies.SHIELDED_RUSHER_GOLD_DROP_COUNT
	gold_drop_chance = Enemies.SHIELDED_RUSHER_GOLD_DROP_CHANCE
	xp_drop_count = Enemies.SHIELDED_RUSHER_XP_DROP_COUNT
	xp_type = Enemies.SHIELDED_RUSHER_XP_TYPE
	min_spawn_dist = Enemies.SHIELDED_RUSHER_MIN_SPAWN_DIST
	spawn_radius = Enemies.SHIELDED_RUSHER_SPAWN_RADIUS

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		Utils.spawn_hit_effect(Color(255, 0, 0, 50), position, damage)
		parent.take_damage(damage)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var angle = Time.get_ticks_msec() / 1000.0
	shield1.position.x = original_shield_position1.x + cos(angle) * rotation_radius
	shield1.position.y = original_shield_position1.y + sin(angle) * rotation_radius
	shield1.rotation = angle

	
