extends Entity
class_name Enemy

var gold_drop_count: int
var xp_drop_count: int
var xp_drop_range: int
var gold_drop_range: float
var drop_count: int
var died: bool = false
var enemy_name: String

func reset_modulation() -> void:
	$Sprite.modulate = Color8(255, 255, 255, 255)

func take_damage(damage_taken: float, shooter: Node, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	EventBus.enemy_hit.emit()
	health -= damage_taken
	var tween = create_tween()
	tween.tween_property($Sprite, "modulate", Color8(255, 255, 255, 100), 0.1)
	if health <= 0:
		if not died:
			tween.finished.connect(on_death)
			EventBus.enemy_dead.emit()
			if shooter is Tower:
				shooter.killed_enemy.emit()
			died = true
	else:
		tween.tween_callback(reset_modulation)

	if knockback_direction != Vector2.ZERO:
		knockback_velocity = knockback_direction * PlayerState.knockback

func on_death() -> void:
	Utils.spawn_hit_effect(Color(255, 0, 0, 50), position, damage)
	for i in range(gold_drop_count):
		if GameState.gold_count < GameState.FLOOR_MAX_GOLD:
			GameState.gold_count += 1
			var drop_position = Utils.get_random_position_in_radius(position, gold_drop_range)
			var gold = Scenes.gold_scene.instantiate()
			gold.position = drop_position
			EventBus.arena_spawn.emit(gold)

	for i in range(xp_drop_count):
		if GameState.xp_count < GameState.FLOOR_MAX_XP:
			GameState.xp_count += 1
			var drop_position = Utils.get_random_position_in_radius(position, xp_drop_range)
			var xp = Scenes.xp_scene.instantiate()
			xp.position = drop_position
			EventBus.arena_spawn.emit(xp)
	
	GameState.enemy_counts[enemy_name] -= 1
	PlayerState.enemies_killed += 1
	GameState.enemies_killed_this_stage += 1
	queue_free()
	
