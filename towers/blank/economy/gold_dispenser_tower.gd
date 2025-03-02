extends Tower

@onready var core_sprite: Sprite2D = $CoreSprite
@onready var ring_sprite: Sprite2D = $RingSprite

var rotation_radius: float = 55
var original_ring_position: Vector2

func _init() -> void:
	super()
	base_type = 4
	tower_name = Towers.GOLD_DISPENSER_NAME
	description = Towers.GOLD_DISPENSER_DESCRIPTION
	cost = Towers.GOLD_DISPENSER_COST
	cooldown = Towers.GOLD_DISPENSER_COOLDOWN
	image = Towers.GOLD_DISPENSER_IMAGE
	scene_path = Towers.GOLD_DISPENSER_SCENE_PATH
	shot_timer = cooldown
	
	upgrade1_name = Towers.DOUBLE_GOLD_DISPENSER_NAME
	upgrade1_description = Towers.DOUBLE_GOLD_DISPENSER_DESCRIPTION
	upgrade1_price = Towers.DOUBLE_GOLD_DISPENSER_COST
	upgrade1_image = Towers.DOUBLE_GOLD_DISPENSER_IMAGE
	upgrade1_scene = Scenes.double_gold_dispenser_tower_scene
	
	upgrade2_name = Towers.SLOTS_NAME
	upgrade2_description = Towers.SLOTS_DESCRIPTION
	upgrade2_price = Towers.SLOTS_COST
	upgrade2_image = Towers.SLOTS_IMAGE
	upgrade2_scene = Scenes.slots_tower_scene
	
func _ready() -> void:
	original_ring_position = ring_sprite.position
	
func _physics_process(delta: float) -> void:
	var progress = 1.0 - (shot_timer / cooldown)
	var core_alpha = int(progress * 255)
	core_sprite.modulate = Color8(255, 255, 255, core_alpha)
	
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown 
		dispense()

	var angle = Time.get_ticks_msec() / (1000.0 * (cooldown / 2))
	ring_sprite.position.x = original_ring_position.x + cos(angle) * rotation_radius
	ring_sprite.position.y = original_ring_position.y + sin(angle) * rotation_radius
	
	ring_sprite.rotation = angle

func dispense() -> void:
	if not GameState.wave_started:
		return
	PickupManager.spawn_gold(ring_sprite.global_position)
	var core_tween = create_tween()
	core_tween.tween_property(ring_sprite, "modulate", Color8(510, 510, 0, 200), 0.25)
	core_tween.tween_property(ring_sprite, "modulate", Color8(255, 255, 255, 255), 0.25)
	Utils.spawn_hit_effect(Color8(510, 255, 0, 255), core_sprite.global_position, 5)
	killed_enemy.emit()
