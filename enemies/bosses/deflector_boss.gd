extends Enemy
@onready var shield1: Node2D = $Shield1
@onready var shield2: Node2D = $Shield2
@onready var name_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/NameLabel
@onready var health_bar: ProgressBar = $CanvasLayer/MarginContainer/VBoxContainer/HealthBar
@onready var hurtbox: Area2D = $Hitbox
var rotation_radius: float = 300
var original_shield_position1: Vector2
var original_shield_position2: Vector2
var attack_timer: float = 0
var can_attack: bool = false

func _ready() -> void:
	original_shield_position1 = shield1.position
	original_shield_position2 = shield2.position
	name_label.text = enemy_name
	health_bar.max_value = health
	hurtbox.area_entered.connect(_on_area_entered)

func _init() -> void:
	health = Enemies.DEFLECTOR_BOSS_HEALTH
	damage = Enemies.DEFLECTOR_BOSS_DAMAGE
	speed = Enemies.DEFLECTOR_BOSS_SPEED
	projectile_speed = Enemies.DEFLECTOR_BOSS_PROJECTILE_SPEED
	firerate_cooldown = Enemies.DEFLECTOR_BOSS_FIRERATE_COOLDOWN
	shot_count = Enemies.DEFLECTOR_BOSS_SHOT_COUNT
	distance_threshold = Enemies.DEFLECTOR_BOSS_DISTANCE_THRESHOLD
	enemy_name = Enemies.DEFLECTOR_BOSS_ENEMY_NAME
	gold_drop_range = Enemies.DEFLECTOR_BOSS_GOLD_DROP_RANGE
	xp_type = Enemies.DEFLECTOR_BOSS_XP_TYPE
	xp_drop_range = Enemies.DEFLECTOR_BOSS_XP_DROP_RANGE
	gold_drop_chance = Enemies.DEFLECTOR_BOSS_GOLD_DROP_CHANCE
	gold_drop_count = Enemies.DEFLECTOR_BOSS_GOLD_DROP_COUNT
	xp_drop_count = Enemies.DEFLECTOR_BOSS_XP_DROP_COUNT
	bullet_scale = Enemies.DEFLECTOR_BOSS_BULLET_SCALE
	min_spawn_dist = Enemies.DEFLECTOR_BOSS_MIN_SPAWN_DIST
	spawn_radius = Enemies.DEFLECTOR_BOSS_SPAWN_RADIUS
	item_drop_chance = Enemies.DEFLECTOR_BOSS_ITEM_DROP_CHANCE
	item_drop_count = Enemies.DEFLECTOR_BOSS_ITEM_DROP_COUNT
	is_boss = true

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		if can_attack:
			Utils.spawn_hit_effect(Color(255, 0, 0, 50), position, damage)
			parent.take_damage(damage)
			can_attack = false
			
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	attack_timer += delta
	if attack_timer >= 0.5:
		can_attack = true
	health_bar.value = health
	var angle = Time.get_ticks_msec() / 1000.0
	
	shield1.position.x = original_shield_position1.x + cos(angle) * rotation_radius
	shield1.position.y = original_shield_position1.y + sin(angle) * rotation_radius
	shield1.rotation = angle
	
	shield2.position.x = original_shield_position2.x + cos(angle + PI) * rotation_radius
	shield2.position.y = original_shield_position2.y + sin(angle + PI) * rotation_radius
	shield2.rotation = angle + PI
	
func telegraph_charge():
	var flash_tween = create_tween()
	flash_tween.tween_property($Sprite, "modulate", Color(2, 0.5, 0.5, 1), 0.2)
	flash_tween.tween_property($Sprite, "modulate", Color(1, 1, 1, 1), 0.2)
	
	var shield1_tween = create_tween()
	shield1_tween.tween_property($Shield1/ShieldSprite, "modulate", Color(2, 0.5, 0.5, 1), 0.2)
	shield1_tween.tween_property($Shield1/ShieldSprite, "modulate", Color(1, 1, 1, 1), 0.2)
	
	var shield2_tween = create_tween()
	shield2_tween.tween_property($Shield2/ShieldSprite, "modulate", Color(2, 0.5, 0.5, 1), 0.2)
	shield2_tween.tween_property($Shield2/ShieldSprite, "modulate", Color(1, 1, 1, 1), 0.2)
