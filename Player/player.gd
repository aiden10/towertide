extends CharacterBody2D

@onready var aim_indicator: Sprite2D = $AimIndicator
@onready var tower_placement_indicator: Sprite2D = $TowerPlacementIndicator
@onready var placement_hitbox: Area2D = $TowerPlacementIndicator/PlacementHitbox
@onready var camera: Camera2D = $Camera2D
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var regen_bar: TextureProgressBar = $RegenBar

var push_force: float = 150.0
var shot_timer = PlayerState.firerate
var can_shoot = true
var placing_tower = false
var tower_type = 0
var valid_placement = true
var overlapping_areas: Array[Area2D] = []
var regen_timer = 0

signal clicked

func _ready() -> void:
	clicked.connect(shoot)
	placement_hitbox.area_entered.connect(_check_placement)
	placement_hitbox.area_exited.connect(_on_area_exit)
	EventBus.xp_picked_up.connect(_on_xp_pickup)
	EventBus.gold_picked_up.connect(_on_gold_pickup)
	EventBus.add_item_scene.connect(_add_item_scene)

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * PlayerState.speed
	if Input.is_action_pressed("click"):
		if not placing_tower:
			clicked.emit(get_global_mouse_position())

	if Input.is_action_just_pressed("click"):
		if placing_tower:
			if not valid_placement:
				EventBus.invalid_action.emit()
				return
				
			var new_tower: Tower
			if tower_type == 1:
				PlayerState.gold -= Towers.CROSS_COST
				new_tower = Scenes.cross_tower_scene.instantiate()
			elif tower_type == 2:
				PlayerState.gold -= Towers.SENTRY_COST
				new_tower = Scenes.sentry_tower_scene.instantiate()
			elif tower_type == 3:
				PlayerState.gold -= Towers.SPAWNER_COST
				new_tower = Scenes.spawner_tower_scene.instantiate()
			
			new_tower.global_position = get_global_mouse_position()
			EventBus.arena_spawn.emit(new_tower)

			placing_tower = false
			tower_type = 0
			aim_indicator.visible = true
			tower_placement_indicator.visible = false
			EventBus.tower_placed.emit()
			EventBus.tower1_deselected.emit()
			EventBus.tower2_deselected.emit()
			EventBus.tower3_deselected.emit()
			EventBus.tower4_deselected.emit()

		else:
			clicked.emit(get_global_mouse_position())

	if Input.is_action_just_pressed("place_tower1"):
		toggle_tower_placement(1, Towers.CROSS_COST, EventBus.tower1_selected, EventBus.tower1_deselected)
	elif Input.is_action_just_pressed("place_tower2"):
		toggle_tower_placement(2, Towers.SENTRY_COST, EventBus.tower2_selected, EventBus.tower2_deselected)
	elif Input.is_action_just_pressed("place_tower3"):
		toggle_tower_placement(3, Towers.SPAWNER_COST, EventBus.tower3_selected, EventBus.tower3_deselected)

func toggle_tower_placement(tower_id: int, cost: int, select_event, deselect_event):
	if PlayerState.gold >= cost:
		if tower_type == tower_id:
			deselect_event.emit()
			tower_type = 0
			aim_indicator.visible = true
			tower_placement_indicator.visible = false
			placing_tower = false
		else:
			select_event.emit()
			tower_type = tower_id
			tower_placement_indicator.visible = true
			aim_indicator.visible = false
			placing_tower = true
	else:
		EventBus.invalid_action.emit()

func _physics_process(delta: float) -> void:
	get_input()
	process_regen(delta)

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
	GameState.player_position = global_position
	health_bar.max_value = PlayerState.max_health
	health_bar.value = PlayerState.health
	check_door()

	if placing_tower:
		tower_placement_indicator.position = to_local(get_global_mouse_position())
		if valid_placement:
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

func process_regen(delta: float) -> void:
	regen_timer += delta
	regen_bar.max_value = PlayerState.regen_cooldown
	regen_bar.value = regen_timer
	if regen_timer >= PlayerState.regen_cooldown:
		EventBus.player_regenerated.emit()
		var regen_tween = create_tween()
		PlayerState.health = min(PlayerState.health + PlayerState.regen, PlayerState.max_health)
		regen_tween.tween_property(health_bar, "modulate", Color8(0, 510, 0, 255), 0.5).set_ease(Tween.EASE_IN)
		regen_tween.tween_property(health_bar, "modulate", Color(1, 1, 1, 1), 0.3)
		Utils.spawn_hit_effect(Color8(0, 510, 0, 255), global_position, max(PlayerState.regen * 5, 5))
		regen_timer = 0

func _add_item_scene(item_scene: PackedScene) -> void:
	if item_scene == Scenes.sword_scene:
		var sword_rotation = 0
		var sword_position = Vector2(100, 0)

		PlayerState.swords_added += 1
		if PlayerState.swords_added == 2:
			sword_rotation = 180
			sword_position = Vector2(-100, 2)
		elif PlayerState.swords_added == 3:
			sword_rotation = 90
			sword_position = Vector2(0, 100)
		elif PlayerState.swords_added == 4:
			sword_rotation = 270
			sword_position = Vector2(0, -100)

		var sword_instance = item_scene.instantiate()
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
	valid_placement = true
		 
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
			valid_placement = false
			break

func shoot(mouse_position: Vector2):
	if can_shoot and not placing_tower:
		var bullet = Scenes.player_projectile_scene.instantiate()
		GameState.player_projectiles[bullet] = 1
		bullet.position = position
		bullet.start(mouse_position, PlayerState.projectile_speed, PlayerState.damage, self)
		EventBus.arena_spawn.emit(bullet)
		EventBus.player_shot.emit()
		can_shoot = false

func take_damage(damage_taken: int, shooter: Node):
	EventBus.player_hit.emit()
	PlayerState.health -= damage_taken

func level_up():
	PlayerState.level += 1
	PlayerState.levels_available += 1
	PlayerState.xp = 0
	PlayerState.level_up_condition = round(100 * (1.1 ** PlayerState.level) / 5) * 5
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
