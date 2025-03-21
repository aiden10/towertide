extends CharacterBody2D

@onready var aim_indicator: Sprite2D = $AimIndicator
@onready var tower_placement_indicator: Sprite2D = $TowerPlacementIndicator
@onready var selected_tower_sprite: Sprite2D = $SelectedTowerSprite
@onready var placement_hitbox: Area2D = $TowerPlacementIndicator/PlacementHitbox
@onready var hitbox: Area2D = $Hitbox
@onready var camera: Camera2D = $Camera2D
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var regen_bar: TextureProgressBar = $RegenBar
@onready var firerate_bar: TextureProgressBar = $FirerateBar
@onready var regen_timer: Timer = $RegenTimer
@onready var placement_timer: Timer = $PlacementTimer

var tower_preview_size = Vector2(72, 72)  
var push_force: float = 150
var shot_timer: float = PlayerState.firerate
var visual_shot_timer: float = 0.0
var visual_firerate_max: float = 3.0  
var can_shoot: bool = true
var placement_timer_up: bool = false
var overlapping_areas: Array[Area2D] = []
var added_items: Dictionary = {}
var base_tower_sprites: Dictionary = {
	1: Towers.CROSS_IMAGE,
	2: Towers.SENTRY_IMAGE,
	3: Towers.SPAWNER_IMAGE,
	4: Towers.BLANK_IMAGE
}

func _ready() -> void:
	position = GameState.player_position
	EventBus.clicked.connect(shoot)
	placement_hitbox.area_entered.connect(_check_placement)
	placement_hitbox.area_exited.connect(_on_area_exit)
	hitbox.area_entered.connect(_on_hitbox_enter)
	hitbox.area_exited.connect(_on_hitbox_exit)
	EventBus.xp_picked_up.connect(_on_xp_pickup)
	EventBus.gold_picked_up.connect(_on_gold_pickup)
	EventBus.toggle_tower_selection.connect(toggle_tower_placement)
	EventBus.tower1_selected.connect(_reset_tower_placement_timer)
	EventBus.tower2_selected.connect(_reset_tower_placement_timer)
	EventBus.tower3_selected.connect(_reset_tower_placement_timer)
	EventBus.tower4_selected.connect(_reset_tower_placement_timer)
	EventBus.unselect_pressed.connect(cancel_tower_placement)
	EventBus._item_aquired.connect(_add_item_scenes)
	regen_timer.wait_time = PlayerState.regen_cooldown
	regen_timer.timeout.connect(_on_regen_timer_timeout)
	regen_timer.start()
	_add_item_scenes()

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * PlayerState.speed
			
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner and focus_owner is not Button and focus_owner is not TextureButton:
		return

	if Input.is_action_pressed("click"):
		if not GameState.placing_tower:
			EventBus.clicked.emit(get_global_mouse_position())

	if Input.is_action_just_released("click"):
		if GameState.placing_tower:
			if not GameState.valid_placement:
				EventBus.invalid_action.emit()
				return
				
			if not placement_timer_up:
				return
			
			var new_tower: Tower
			if GameState.tower_type == 1:
				PlayerState.gold -= Towers.CROSS_COST
				PlayerState.sprayer_count += 1
				new_tower = Scenes.cross_tower_scene.instantiate()
			elif GameState.tower_type == 2:
				PlayerState.gold -= Towers.SENTRY_COST
				PlayerState.sentry_count += 1
				new_tower = Scenes.sentry_tower_scene.instantiate()
			elif GameState.tower_type == 3:
				PlayerState.gold -= Towers.SPAWNER_COST
				PlayerState.spawner_count += 1
				new_tower = Scenes.spawner_tower_scene.instantiate()
			elif GameState.tower_type == 4:
				PlayerState.gold -= Towers.BLANK_COST
				PlayerState.blank_count += 1
				new_tower = Scenes.blank_tower_scene.instantiate()
			
			new_tower.global_position = get_global_mouse_position()
			EventBus.arena_spawn.emit(new_tower)
			EventBus.tower_placed.emit()
			EventBus.unselect_pressed.emit()
		else:
			EventBus.clicked.emit(get_global_mouse_position())
			
func update_tower_preview(tower_id: int):
	var tower_texture = base_tower_sprites[tower_id]
	selected_tower_sprite.texture = tower_texture
	var tex_size = tower_texture.get_size()
	selected_tower_sprite.scale = Vector2(
		tower_preview_size.x / tex_size.x,
		tower_preview_size.y / tex_size.y
	)
	
func _reset_tower_placement_timer() -> void:
	placement_timer_up = false
	placement_timer.start()
	placement_timer.timeout.connect(func(): placement_timer_up = true)

func cancel_tower_placement() -> void:
	EventBus.tower1_deselected.emit()
	EventBus.tower2_deselected.emit()
	EventBus.tower3_deselected.emit()
	EventBus.tower4_deselected.emit()
	GameState.tower_type = 0
	aim_indicator.visible = true
	tower_placement_indicator.visible = false
	selected_tower_sprite.visible = false
	GameState.placing_tower = false

func toggle_tower_placement(tower_id: int, cost: int, select_event):
	EventBus.tower1_deselected.emit()
	EventBus.tower2_deselected.emit()
	EventBus.tower3_deselected.emit()
	EventBus.tower4_deselected.emit()

	if PlayerState.gold + PlayerState.minimum_gold >= cost:
		if GameState.tower_type == tower_id:
			cancel_tower_placement()
		else:
			select_event.emit()
			GameState.tower_type = tower_id
			tower_placement_indicator.visible = true
			selected_tower_sprite.visible = true
			aim_indicator.visible = false
			GameState.placing_tower = true
			update_tower_preview(tower_id)
	else:
		EventBus.invalid_action.emit()

func _physics_process(delta: float) -> void:
	get_input()

	look_at(get_global_mouse_position())
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		var push_direction = (collider.global_position - global_position).normalized()
		collider.position += push_direction * push_force * delta

	shot_timer += delta
	if shot_timer >= PlayerState.firerate:
		can_shoot = true
		
	# Update the visual timer at a slower pace
	if not can_shoot:
		visual_shot_timer = min(visual_shot_timer + delta * (visual_firerate_max / PlayerState.firerate), visual_firerate_max)
	elif visual_shot_timer < visual_firerate_max:
		visual_shot_timer = visual_firerate_max  # Ensure it's full when can_shoot is true
		
func _process(delta: float) -> void:
	GameState.player_position = position
	health_bar.max_value = PlayerState.max_health
	health_bar.value = PlayerState.health
	regen_bar.max_value = PlayerState.regen_cooldown
	regen_bar.value = PlayerState.regen_cooldown - regen_timer.time_left
	firerate_bar.max_value = visual_firerate_max
	firerate_bar.value = visual_shot_timer

	check_door()

	if GameState.placing_tower:
		tower_placement_indicator.position = to_local(get_global_mouse_position())
		selected_tower_sprite.position = to_local(get_global_mouse_position())
		selected_tower_sprite.rotation = -global_rotation
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

func _add_item_scenes() -> void:
	for item in PlayerState.player_items:
		## Not yet added and has a scene
		if item not in added_items.values() and item.scene:
			var item_scene = item.scene.instantiate()
			add_child(item_scene)

func _on_hitbox_enter(area: Area2D) -> void:
	if area.is_in_group("Pickups"):
		area.player = self
		area.in_attract_range = true

func _on_hitbox_exit(area: Area2D) -> void:
	if area.is_in_group("Pickups"):
		area.player = null
		area.in_attract_range = false

func _check_placement(area: Area2D) -> void:
	overlapping_areas.append(area)
	_update_placement_validity()

func _on_area_exit(area: Area2D) -> void:
	overlapping_areas.erase(area)
	_update_placement_validity()

func _update_placement_validity() -> void:		
	GameState.valid_placement = true
	for area in overlapping_areas:
		var parent = area.get_parent()
		# Groups that don't count as invalid areas
		if (not area.is_in_group("Pickups")
	 	and not parent.is_in_group("Pickups")
		and not parent.is_in_group("Sword")
		and not area.is_in_group("EnemyProjectiles")
		and not area.is_in_group("FriendlyProjectiles")
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
		shot_timer = 0
		visual_shot_timer = 0

func take_damage(damage_taken: int):
	EventBus.player_hit.emit()
	PlayerState.health -= damage_taken
	if PlayerState.health <= 0:
		EventBus.player_died.emit()

func level_up():
	PlayerState.level += 1
	PlayerState.levels_available += 1
	PlayerState.xp = 0
	PlayerState.level_up_condition = round(50 * (1.3 ** PlayerState.level) / 5) * 5
	EventBus.level_up.emit()
	
func _on_xp_pickup(xp_type: int):
	if xp_type == 1:
		PlayerState.xp += 1
	elif xp_type == 2:
		PlayerState.xp += 5

	if PlayerState.xp >= PlayerState.level_up_condition:
		level_up()

func _on_gold_pickup():
	PlayerState.gold += 1

func apply_player_bullet_effects():
	for bullet in GameState.player_projectiles.keys():
		pass
