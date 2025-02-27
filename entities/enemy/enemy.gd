extends Entity
class_name Enemy

var item_drop_count: int = 0
var gold_drop_count: int
var xp_type: int = 1
var xp_drop_count: int
var xp_drop_range: int
var gold_drop_range: float
var died: bool = false
var enemy_name: String
var bullet_scale: float = 1.0
var gold_drop_chance: float = 1.0
var item_drop_chance: float = 0
var min_spawn_dist: float
var spawn_radius: float
var shot_count: int = 1
var is_boss: bool = false

func reset_modulation() -> void:
	for child in get_children():
		if child is Sprite2D:
			child.modulate = Color8(255, 255, 255, 255)

func take_damage(damage_taken: float, shooter: Node, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	EventBus.enemy_hit.emit()
	health -= damage_taken
	for child in get_children():
		if child is Sprite2D:
			var tween = create_tween()
			tween.tween_property(child, "modulate", Color8(255, 255, 255, 100), 0.1)
			tween.tween_callback(reset_modulation)

	if health <= 0:
		if not died:
			EventBus.enemy_dead.emit()
			if shooter is Tower:
				shooter.killed_enemy.emit()
			died = true
			on_death()

	if knockback_direction != Vector2.ZERO:
		knockback_velocity = knockback_direction * PlayerState.knockback

func on_death() -> void:
	for i in range(gold_drop_count):
		if randf() > gold_drop_chance:
			continue
		var drop_position = Utils.get_random_position_in_radius(position, gold_drop_range)
		PickupManager.spawn_gold(drop_position)

	for i in range(xp_drop_count):
		var drop_position = Utils.get_random_position_in_radius(position, xp_drop_range)
		PickupManager.spawn_xp(drop_position, xp_type)
	
	for i in range(item_drop_count):
		if randf() > item_drop_chance:
			continue
		var drop_position = Utils.get_random_position_in_radius(position, 50)
		PickupManager.spawn_item(drop_position)
	
	if is_boss:
		GameState.boss_dead = true
		EventBus._boss_dead.emit()
		
	GameState.enemy_counts[enemy_name] -= 1
	PlayerState.enemies_killed += 1
	GameState.enemies_killed_this_stage += 1
	queue_free()
	
