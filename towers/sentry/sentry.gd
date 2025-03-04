extends Tower
class_name Sentry

var can_shoot: bool = false
var angle_offset: float = 0
var target_enemy_position: Vector2 = Vector2.ZERO
var potential_enemies: Array[Enemy] = []
var shot_count: int = 1

func _init() -> void:
	super()
	base_type = 2

func enemy_detected(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemies") and not parent.is_in_group("Stealth"):
		if parent not in potential_enemies:
			potential_enemies.append(parent)
		target_enemy_position = Vector2.ZERO
		if potential_enemies.size() > 0:
			if is_instance_valid(potential_enemies[0]):
				target_enemy_position = potential_enemies[0].global_position
			else:
				potential_enemies.pop_front()

		if can_shoot and target_enemy_position != Vector2.ZERO:
			var angle: float = 30
			var middle_index = shot_count / 2
			for i in range(shot_count):
				if tower_name != Towers.GRAPESHOT_NAME:
					var offset = (i - middle_index) * angle
					shoot(target_enemy_position, angle_offset, offset)
				else:
					var random_offset: float = randf_range(1, 20)
					shoot(target_enemy_position, angle_offset, random_offset)
					await get_tree().create_timer(0.01).timeout

func shoot(enemy_position: Vector2, angle: float, offset: float = 0) -> void:
	var direction = (enemy_position - position).normalized()
	var shot_angle_offset = deg_to_rad(offset)
	var rotated_direction = direction.rotated(shot_angle_offset)

	EventBus.tower_shot.emit()
	look_at(enemy_position)
	rotation_degrees += angle
	can_shoot = false
	var bullet = Scenes.player_projectile_scene.instantiate()
	GameState.player_projectiles[bullet] = 1
	bullet.position = position
	bullet.start(position + rotated_direction * 10, PlayerState.projectile_speed * bullet_speed, PlayerState.damage * damage_scale, self, bullet_scale)
	EventBus.arena_spawn.emit(bullet)
	potential_enemies.clear()
	
