extends Tower
class_name Sentry

var can_shoot: bool = false
var angle_offset: float = 0
var enemy_position: Vector2 = Vector2.ZERO
var potential_enemies: Array[Enemy] = []

func _init() -> void:
	super()
	base_type = 2

func enemy_detected(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemies"):
		if parent not in potential_enemies:
			potential_enemies.append(parent)
		enemy_position = Vector2.ZERO
		if potential_enemies.size() > 0:
			if is_instance_valid(potential_enemies[0]):
				enemy_position = potential_enemies[0].global_position
			else:
				potential_enemies.pop_front()
				
		if can_shoot and enemy_position != Vector2.ZERO:
			shoot(enemy_position, angle_offset)

func shoot(enemy_position: Vector2, angle: float) -> void:
	EventBus.tower_shot.emit()
	look_at(enemy_position)
	rotation_degrees += angle

	can_shoot = false
	var bullet = Scenes.player_projectile_scene.instantiate()
	GameState.player_projectiles[bullet] = 1
	bullet.position = position

	bullet.start(enemy_position, PlayerState.projectile_speed * bullet_speed, PlayerState.damage * damage_scale, self, bullet_scale)
	EventBus.arena_spawn.emit(bullet)
	potential_enemies.clear()
	
