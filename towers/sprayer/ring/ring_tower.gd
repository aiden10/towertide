extends Tower

@onready var ring: Sprite2D = $Ring
@onready var ring_hitbox: Area2D = $Ring/Area2D
var can_hit = false

func _init() -> void:
	super()
	base_type = 1
	tower_name = Towers.RING_NAME
	description = Towers.RING_DESCRIPTION
	cost = Towers.RING_COST
	value = cost
	cooldown = Towers.RING_COOLDOWN
	damage_scale = Towers.RING_DAMAGE_PERCENTAGE
	shot_timer = cooldown
	image = Towers.RING_IMAGE
	scene_path = Towers.RING_SCENE_PATH

func _ready() -> void:
	var pulse_tween = create_tween()
	pulse_tween.set_loops(-1)
	pulse_tween.set_trans(Tween.TRANS_SINE)
	pulse_tween.set_ease(Tween.EASE_IN_OUT)
	
	pulse_tween.tween_property(ring, "scale", Vector2(2, 2), 3)
	pulse_tween.tween_property(ring, "scale", Vector2(0.1, 0.1), 1.5)
	
	ring_hitbox.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemies") and can_hit:
		parent.take_damage(damage_scale * PlayerState.damage, self)

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		can_hit = true

	for area in ring_hitbox.get_overlapping_areas():
		var parent = area.get_parent()
		if parent.is_in_group("Enemies") and can_hit:
			parent.take_damage(damage_scale * PlayerState.damage, self)
			Utils.spawn_hit_effect(Color(0, 0.5, 2, 1), area.global_position, max(5, PlayerState.damage * damage_scale))

	can_hit = false
