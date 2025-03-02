extends Tower

@onready var core_sprite: Sprite2D = $CoreSprite
@onready var ring_sprite: Sprite2D = $RingSprite
@onready var ring_sprite2: Sprite2D = $RingSprite2

var gold_scene: PackedScene = Scenes.gold_scene
var rotation_radius: float = 55
var original_ring_position: Vector2
var original_ring_position2: Vector2

func _init() -> void:
	super()
	base_type = 4
	tower_name = Towers.DOUBLE_GOLD_DISPENSER_NAME
	description = Towers.DOUBLE_GOLD_DISPENSER_DESCRIPTION
	cost = Towers.DOUBLE_GOLD_DISPENSER_COST
	cooldown = Towers.DOUBLE_GOLD_DISPENSER_COOLDOWN
	image = Towers.DOUBLE_GOLD_DISPENSER_IMAGE
	scene_path = Towers.DOUBLE_GOLD_DISPENSER_SCENE_PATH
	shot_timer = cooldown

func _ready() -> void:
	original_ring_position = ring_sprite.position
	original_ring_position2 = ring_sprite2.position
	
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

	ring_sprite2.position.x = original_ring_position2.x + cos(angle + PI) * rotation_radius
	ring_sprite2.position.y = original_ring_position2.y + sin(angle + PI) * rotation_radius
	
	ring_sprite2.rotation = angle + PI

func dispense() -> void:
	if not GameState.wave_started:
		return
	PickupManager.spawn_gold(ring_sprite.global_position)
	PickupManager.spawn_gold(ring_sprite2.global_position)
	var core_tween = create_tween()
	core_tween.tween_property(ring_sprite, "modulate", Color8(510, 510, 0, 200), 0.25)
	core_tween.tween_property(ring_sprite, "modulate", Color8(255, 255, 255, 255), 0.25)
	Utils.spawn_hit_effect(Color8(510, 255, 0, 255), core_sprite.global_position, 5)
	killed_enemy.emit()
