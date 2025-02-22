extends CharacterBody2D

@onready var aim_indicator: Sprite2D = $AimIndicator
@onready var tower_placement_indicator: Sprite2D = $TowerPlacementIndicator
@onready var placement_hitbox: Area2D = $TowerPlacementIndicator/PlacementHitbox

var shot_timer = PlayerState.firerate
var can_shoot = true
var placing_tower = false
var tower_type = 0
var valid_placement = true
var overlapping_areas: Array[Area2D] = []
var regen_timer = PlayerState.regen_cooldown
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
	velocity = input_dir * PlayerConstants.DEFAULT_PLAYER_SPEED
	if Input.is_action_pressed("click"):
		if not placing_tower:
			clicked.emit(get_global_mouse_position())
		
	if Input.is_action_just_pressed("click"):
		if placing_tower:
			if not valid_placement:
				return
			if tower_type == 1:
				PlayerState.gold -= Towers.CROSS_COST
				var new_tower = Scenes.cross_tower_scene.instantiate()
				new_tower.global_position = get_global_mouse_position()
				EventBus.arena_spawn.emit(new_tower)

			placing_tower = false
			tower_type = 0
			aim_indicator.visible = true
			tower_placement_indicator.visible = false
			EventBus.tower1_deselected.emit()

		else:
			clicked.emit(get_global_mouse_position())

	if Input.is_action_just_pressed("place_tower1"):
		if PlayerState.gold >= Towers.CROSS_COST:
			if placing_tower:
				EventBus.tower1_deselected.emit()
				tower_type = 0
				aim_indicator.visible = true
				tower_placement_indicator.visible = false
				placing_tower = false
			else:
				EventBus.tower1_selected.emit()
				tower_type = 1
				tower_placement_indicator.visible = true
				aim_indicator.visible = false
				placing_tower = true

func _process(delta: float) -> void:
	if placing_tower:
		tower_placement_indicator.position = to_local(get_global_mouse_position())
		if valid_placement:
			tower_placement_indicator.modulate = Color8(0, 510, 0, 75)
		else:
			tower_placement_indicator.modulate = Color8(510, 0, 0, 75)
	for item in PlayerState.player_items:
		item.use(delta)

func process_regen(delta: float) -> void:
	regen_timer -= delta 
	if regen_timer <= 0:
		PlayerState.health += PlayerState.regen
		regen_timer = PlayerState.regen_cooldown

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
		# If we find any invalid area, mark as invalid and break
		if not parent.is_in_group("Pickups") and not parent.is_in_group("Sword") and not area.is_in_group("Projectiles"):
			valid_placement = false
			break

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
	if can_shoot and not placing_tower:
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
	PlayerState.levels_available += 1
	PlayerState.xp = 0
	PlayerState.level_up_condition = PlayerConstants.BASE_XP * (PlayerConstants.LEVEL_MULTIPLIER ** PlayerState.level)
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
