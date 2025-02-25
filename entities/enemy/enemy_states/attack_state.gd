extends State

var firerate = 0
var can_shoot
var player

func enter() -> void:
	can_shoot = true
	player = get_tree().get_first_node_in_group("Player")

func update(delta: float):
	var direction = player.global_position - enemy.global_position
	if direction.length() > enemy.distance_threshold:
		transitioned.emit(self, "follow")
		return

	if firerate > 0:
		firerate -= delta

	if firerate <= 0:
		can_shoot = true
		firerate = enemy.firerate_cooldown
		shoot(player.position)

func shoot(player_position: Vector2):
	if can_shoot:
		EventBus.enemy_shot.emit()
		var bullet = Scenes.enemy_projectile_scene.instantiate()
		bullet.position = enemy.position
		bullet.start(player_position, enemy.projectile_speed, enemy.damage, get_parent(), enemy.bullet_scale)
		can_shoot = false
		EventBus.arena_spawn.emit(bullet)
