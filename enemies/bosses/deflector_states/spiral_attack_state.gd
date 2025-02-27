extends State
var attack_duration: float = 3.0
var timer: float = 0
var shot_timer: float = 0
var shot_interval: float = 0.1
var current_angle: float = 0

func enter() -> void:
	timer = attack_duration
	shot_timer = 0
	current_angle = 0

func update(delta: float):
	timer -= delta
	shot_timer -= delta
	
	if timer <= 0:
		transitioned.emit(self, "follow")
		return
		
	if shot_timer <= 0:
		shot_timer = shot_interval
		shoot_spiral()
		current_angle += 0.3

func shoot_spiral():
	var direction = Vector2(cos(current_angle), sin(current_angle))
	EventBus.enemy_shot.emit()
	var bullet = Scenes.enemy_projectile_scene.instantiate()
	bullet.position = enemy.position
	bullet.start(enemy.position + direction * 10, enemy.projectile_speed * 0.8, enemy.damage, get_parent(), enemy.bullet_scale)
	EventBus.arena_spawn.emit(bullet)
