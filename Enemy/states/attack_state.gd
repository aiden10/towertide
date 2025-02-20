extends State

@export var enemy: Enemy
@export var projectile_scene: PackedScene
var firerate = 0
var can_shoot
var player

func _ready() -> void:
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
		var bullet = projectile_scene.instantiate()
		bullet.position = enemy.position
		bullet.start(player_position, enemy.projectile_speed, enemy.damage, "enemy")
		get_tree().current_scene.add_child(bullet)
		can_shoot = false
