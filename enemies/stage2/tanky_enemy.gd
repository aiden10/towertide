extends Enemy

@onready var hitbox1: Area2D = $Hitbox
@onready var hitbox2: Area2D = $Hitbox2
@onready var hitbox3: Area2D = $Hitbox3

func _init() -> void:
	health = Enemies.TANKY_HEALTH
	damage = Enemies.TANKY_DAMAGE
	speed = Enemies.TANKY_SPEED
	enemy_name = Enemies.TANKY_ENEMY_NAME
	gold_drop_range = Enemies.TANKY_GOLD_DROP_RANGE
	xp_drop_range = Enemies.TANKY_XP_DROP_RANGE
	gold_drop_count = Enemies.TANKY_GOLD_DROP_COUNT
	xp_drop_count = Enemies.TANKY_XP_DROP_COUNT

func _ready() -> void:
	hitbox1.area_entered.connect(_on_area_entered)
	hitbox2.area_entered.connect(_on_area_entered)
	hitbox3.area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		Utils.spawn_hit_effect(Color(255, 0, 0, 50), position, damage)
		parent.take_damage(damage)
		queue_free()
