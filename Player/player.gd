extends CharacterBody2D

var shot_timer = PlayerState.firerate
var can_shoot = true

signal clicked

func _ready() -> void:
	clicked.connect(shoot)
	EventBus.xp_picked_up.connect(_on_xp_pickup)
	EventBus.gold_picked_up.connect(_on_gold_pickup)

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * PlayerConstants.DEFAULT_PLAYER_SPEED
	if Input.is_action_pressed("click"):
		clicked.emit(get_global_mouse_position())

func _process(delta: float) -> void:
	for item in PlayerState.player_items:
		item.use(delta)

func _physics_process(delta: float) -> void:
	get_input()
	look_at(get_global_mouse_position())
	var collision = move_and_collide(velocity * delta)
	if collision:
		EventBus.collided.emit(collision.get_collider())
	if shot_timer > 0:
		shot_timer -= delta
	if shot_timer <= 0:
		can_shoot = true
		shot_timer = PlayerState.firerate

func shoot(mouse_position: Vector2):
	if can_shoot:
		var bullet = Scenes.player_projectile_scene.instantiate()
		GameState.player_projectiles[bullet] = 1
		bullet.position = position
		bullet.start(mouse_position, PlayerState.projectile_speed, PlayerState.damage, "player")
		EventBus.arena_spawn.emit(bullet)
		can_shoot = false

func take_damage(damage_taken: float):
	PlayerState.health -= damage_taken

func level_up():
	PlayerState.level += 1
	PlayerState.xp = 0
	PlayerState.max_health += PlayerState.level * 10
	PlayerState.damage += PlayerState.level
	PlayerState.level_up_condition = PlayerConstants.BASE_XP * (PlayerConstants.LEVEL_MULTIPLIER ** PlayerState.level)

func _on_xp_pickup():
	PlayerState.xp += 1
	if PlayerState.xp >= PlayerState.level_up_condition:
		level_up()
	
func _on_gold_pickup():
	PlayerState.gold += 1

func apply_player_bullet_effects():
	for bullet in GameState.player_projectiles.keys():
		pass
