extends Tower
class_name Sentry

var can_shoot: bool = false
var angle_offset: float = 0
func enemy_detected(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemies"):
		if can_shoot:
			shoot(parent.global_position, angle_offset)

func shoot(enemy_position: Vector2, angle: float) -> void:
	look_at(enemy_position)
	rotation_degrees += angle

	can_shoot = false
	var bullet = Scenes.player_projectile_scene.instantiate()
	GameState.player_projectiles[bullet] = 1
	bullet.position = position

	bullet.start(enemy_position, PlayerState.projectile_speed * Towers.SENTRY_SPEED_PERCENTAGE, PlayerState.damage * Towers.SENTRY_DAMAGE_PERCENTAGE, "player")
	EventBus.arena_spawn.emit(bullet)
