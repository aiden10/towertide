extends CharacterBody2D

@onready var aim_indicator: Sprite2D = $AimIndicator
@onready var tower_placement_indicator: Sprite2D = $TowerPlacementIndicator
@onready var placement_hitbox: Area2D = $TowerPlacementIndicator/PlacementHitbox
@onready var camera: Camera2D = $Camera2D
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var regen_bar: TextureProgressBar = $RegenBar
@onready var regen_timer: Timer = $RegenTimer

var push_force: float = 150.0
var shot_timer = PlayerState.firerate
var can_shoot = true
var overlapping_areas: Array[Area2D] = []

func _ready() -> void:
	position = GameState.player_position
	EventBus.clicked.connect(shoot)
	placement_hitbox.area_entered.connect(_check_placement)
	placement_hitbox.area_exited.connect(_on_area_exit)
	EventBus.xp_picked_up.connect(_on_xp_pickup)
	EventBus.gold_picked_up.connect(_on_gold_pickup)
	EventBus.toggle_tower_selection.connect(toggle_tower_placement)
	EventBus.unselect_pressed.connect(cancel_tower_placement)
	regen_timer.wait_time = PlayerState.regen_cooldown
	regen_timer.timeout.connect(_on_regen_timer_timeout)
	regen_timer.start()
	add_item_scenes()
	
func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * PlayerState.speed
	
	if Input.is_action_pressed("click"):
		if not GameState.placing_tower:
			EventBus.clicked.emit(get_global_mouse_position())
			
	if Input.is_action_just_pressed("click"):
		if GameState.placing_tower:
			if not GameState.valid_placement:
				EventBus.invalid_action.emit()
				return
				
			var new_tower: Tower
			if GameState.tower_type == 1:
				PlayerState.gold -= Towers.CROSS_COST
				new_tower = Scenes.cross_tower_scene.instantiate()
			elif GameState.tower_type == 2:
				PlayerState.gold -= Towers.SENTRY_COST
				new_tower = Scenes.sentry_tower_scene.instantiate()
			elif GameState.tower_type == 3:
				PlayerState.gold -= Towers.SPAWNER_COST
				new_tower = Scenes.spawner_tower_scene.instantiate()
			elif GameState.tower_type == 4:
				PlayerState.gold -= Towers.BLANK_COST
				new_tower = Scenes.blank_tower_scene.instantiate()
			
			new_tower.global_position = get_global_mouse_position()
			EventBus.arena_spawn.emit(new_tower)
			
			EventBus.unselect_pressed.emit()
		else:
			EventBus.clicked.emit(get_global_mouse_position())
			
func cancel_tower_placement() -> void:
	EventBus.tower1_deselected.emit()
	EventBus.tower2_deselected.emit()
	EventBus.tower3_deselected.emit()
	EventBus.tower4_deselected.emit()
	GameState.tower_type = 0
	aim_indicator.visible = true
	tower_placement_indicator.visible = false
	GameState.placing_tower = false
	
func toggle_tower_placement(tower_id: int, cost: int, select_event, deselect_event):
	if PlayerState.gold >= cost:
		if GameState.tower_type == tower_id:
			cancel_tower_placement()
		else:
			select_event.emit()
			GameState.tower_type = tower_id
			tower_placement_indicator.visible = true
			aim_indicator.visible = false
			GameState.placing_tower = true
	else:
		EventBus.invalid_action.emit()

func _physics_process(delta: float) -> void:
	get_input()

	look_at(get_global_mouse_position())
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is Enemy:
			var push_direction = (collider.global_position - global_position).normalized()
			collider.velocity += push_direction * push_force * delta
	move_and_slide()

	if shot_timer > 0:
		shot_timer -= delta
	if shot_timer <= 0:
		can_shoot = true
		shot_timer = PlayerState.firerate

func _process(delta: float) -> void:
	GameState.player_position = position
	health_bar.max_value = PlayerState.max_health
	health_bar.value = PlayerState.health
	regen_bar.max_value = PlayerState.regen_cooldown
	regen_bar.value = PlayerState.regen_cooldown - regen_timer.time_left

	check_door()

	if GameState.placing_tower:
		tower_placement_indicator.position = to_local(get_global_mouse_position())
		if GameState.valid_placement:
			tower_placement_indicator.modulate = Color(0, 2, 0, 0.3)
		else:
			tower_placement_indicator.modulate = Color(2, 0, 0, 0.3)
	for item in PlayerState.player_items:
		item.use(delta)

func check_door() -> void:
	if GameState.door_position != Vector2.ZERO:
		var viewport_rect = Rect2(camera.global_position - (get_viewport_rect().size / 2), get_viewport_rect().size)
		if not viewport_rect.has_point(GameState.door_position):
			EventBus.door_visible.emit()
		else:
			EventBus.door_not_visible.emit()

func _on_regen_timer_timeout() -> void:
	EventBus.player_regenerated.emit()
	var regen_tween = create_tween()
	PlayerState.health = min(PlayerState.health + PlayerState.regen, PlayerState.max_health)
	regen_tween.tween_property(health_bar, "modulate", Color8(0, 510, 0, 255), 0.5).set_ease(Tween.EASE_IN)
	regen_tween.tween_property(health_bar, "modulate", Color(1, 1, 1, 1), 0.3)
	Utils.spawn_hit_effect(Color8(0, 510, 0, 255), global_position, max(PlayerState.regen * 5, 5))

func add_item_scenes() -> void:
	if Items.SWORD_NAME in PlayerState.item_counts:
		var sword_count = PlayerState.item_counts[Items.SWORD_NAME]
		for i in range(sword_count):
			var sword_rotation = 0
			var sword_position = Vector2(101, 0)
			if i == 1:
				sword_rotation = 180
				sword_position = Vector2(-100, 2)
			elif i == 2:
				sword_rotation = 90
				sword_position = Vector2(0, 100)
			elif i == 3:
				sword_rotation = 270
				sword_position = Vector2(0, -100)

			var sword_instance = Items.all_items[Items.SWORD_NAME].scene.instantiate()
			sword_instance.position = sword_position
			sword_instance.rotation_degrees = sword_rotation
			add_child(sword_instance)

func _check_placement(area: Area2D) -> void:
	overlapping_areas.append(area)
	_update_placement_validity()

func _on_area_exit(area: Area2D) -> void:
	overlapping_areas.erase(area)
	_update_placement_validity()

func _update_placement_validity() -> void:
	# Start with assumption that placement is valid
	GameState.valid_placement = true
		 
	# Check all currently overlapping areas
	for area in overlapping_areas:
		var parent = area.get_parent()
		# Groups that don't count as invalid areas
		if (not area.is_in_group("Pickups")
	 	and not parent.is_in_group("Pickups")
		and not parent.is_in_group("Sword")
		and not area.is_in_group("Projectiles")
		and not area.is_in_group("DetectionRadius")
		):
			GameState.valid_placement = false
			break

func shoot(mouse_position: Vector2):
	if can_shoot and not GameState.placing_tower:
		var bullet = Scenes.player_projectile_scene.instantiate()
		GameState.player_projectiles[bullet] = 1
		bullet.position = position
		bullet.start(mouse_position, PlayerState.projectile_speed, PlayerState.damage, self)
		EventBus.arena_spawn.emit(bullet)
		EventBus.player_shot.emit()
		can_shoot = false

func take_damage(damage_taken: int):
	EventBus.player_hit.emit()
	PlayerState.health -= damage_taken
	if PlayerState.health <= 0:
		EventBus.player_died.emit()

func level_up():
	PlayerState.level += 1
	PlayerState.levels_available += 1
	PlayerState.xp = 0
	PlayerState.level_up_condition = round(100 * (1.2 ** PlayerState.level) / 5) * 5
	EventBus.level_up.emit()
	
func _on_xp_pickup():
	PlayerState.xp += 1
	if PlayerState.xp >= PlayerState.level_up_condition:
		level_up()

func _on_gold_pickup():
	PlayerState.gold += 1

func apply_player_bullet_effects():
	for bullet in GameState.player_projectiles.keys():
		pass
