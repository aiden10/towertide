extends Entity
class_name Enemy

var gold_drop_count: int
var xp_drop_count: int
var xp_drop_range: int
var gold_drop_range: float
var drop_count: int
var died: bool = false

func reset_modulation() -> void:
	$Sprite.modulate = Color8(255, 255, 255, 255)

func take_damage(damage_taken: float, shooter: Node, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	health -= damage_taken
	var tween = create_tween()
	tween.tween_property($Sprite, "modulate", Color8(255, 255, 255, 100), 0.1)
	if health <= 0:
		if not died:
			tween.finished.connect(on_death)
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
		var drop_position = Utils.get_random_position_in_radius(position, gold_drop_range)
		var gold = Scenes.gold_scene.instantiate()
		gold.position = drop_position
		EventBus.arena_spawn.emit(gold)

	for i in range(xp_drop_count):
		var drop_position = Utils.get_random_position_in_radius(position, xp_drop_range)
		var xp = Scenes.xp_scene.instantiate()
		xp.position = drop_position
		EventBus.arena_spawn.emit(xp)
	
	PlayerState.enemies_killed += 1
	queue_free()
	
