extends Enemy

@onready var hurtbox: Area2D = $Hurtbox
var player_in_hurtbox

func _init() -> void:
	health = Enemies.TANKY_HEALTH
	damage = Enemies.TANKY_DAMAGE
	speed = Enemies.TANKY_SPEED
	enemy_name = Enemies.TANKY_ENEMY_NAME
	gold_drop_range = Enemies.TANKY_GOLD_DROP_RANGE
	xp_drop_range = Enemies.TANKY_XP_DROP_RANGE
	gold_drop_count = Enemies.TANKY_GOLD_DROP_COUNT
	xp_drop_count = Enemies.TANKY_XP_DROP_COUNT
	xp_type = Enemies.TANKY_XP_TYPE
	min_spawn_dist = Enemies.TANKY_MIN_SPAWN_DIST
	spawn_radius = Enemies.TANKY_SPAWN_RADIUS
	item_drop_chance = Enemies.TANKY_ITEM_DROP_CHANCE
	item_drop_count = Enemies.TANKY_ITEM_DROP_COUNT

func _ready() -> void:
	hurtbox.area_entered.connect(_on_area_entered)
	hurtbox.area_exited.connect(_on_area_exited)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if player_in_hurtbox != null:
		damage_timer += delta
		if damage_timer >= firerate_cooldown:
			_apply_damage_to_player()
			damage_timer = 0.0

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		player_in_hurtbox = parent

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player") and parent == player_in_hurtbox:
		player_in_hurtbox = null

func _apply_damage_to_player() -> void:
	if player_in_hurtbox != null:
		Utils.spawn_hit_effect(Color(255, 0, 0, 50), player_in_hurtbox.position, damage)
		player_in_hurtbox.take_damage(damage)
