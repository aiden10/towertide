extends Sentry

@onready var sprite: Sprite2D = $Sprite
@onready var barrel: Marker2D = $Barrel
@onready var shoot_container: PanelContainer = $ShootContainer
@onready var shoot_label: Label = $ShootContainer/ShootLabel
@onready var fire_progress: ProgressBar = $FireProgressBar

func _init() -> void:
	super()
	tower_name = Towers.CANNON_NAME
	description = Towers.CANNON_DESCRIPTION
	cost = Towers.CANNON_COST
	value = cost
	cooldown = Towers.CANNON_COOLDOWN
	damage_scale = Towers.CANNON_DAMAGE_PERCENTAGE
	shot_timer = cooldown
	bullet_scale = Towers.CANNON_BULLET_SCALE
	bullet_speed = Towers.CANNON_SPEED_PERCENTAGE
	image = Towers.CANNON_IMAGE
	scene_path = Towers.CANNON_SCENE_PATH

func _ready() -> void:
	shot_timer = cooldown
	fire_progress.max_value = cooldown
	shoot_container.modulate = Color(1, 1, 1, 0)
	shoot_container.position = Vector2(-85, -125) + global_position
	fire_progress.position = Vector2(-40, 75) + global_position
	shoot_label.text = "Press " + Utils.get_action_key_name("fire") + " to fire, " + Utils.get_action_key_name("rotate") + " to face mouse"
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire"):
		if not can_shoot:
			EventBus.invalid_action.emit()
		else:
			fire()

	if Input.is_action_just_pressed("rotate"):
		look_at(get_global_mouse_position())
		rotation += deg_to_rad(90)

func fire() -> void:
	shot_timer = 0
	var direction = Vector2(cos(rotation + deg_to_rad(270)), sin(rotation + deg_to_rad(270)))
	var spawn_offset = direction * 20
	var target_position = position + direction * 1000 	
	EventBus.tower_shot.emit()
	var bullet = Scenes.player_projectile_scene.instantiate()
	GameState.player_projectiles[bullet] = 1
	bullet.position = barrel.global_position + spawn_offset
	
	bullet.start(target_position, bullet_speed, PlayerState.damage * damage_scale, self, bullet_scale, Towers.CANNON_EXTRA_PIERCE)
	Utils.spawn_hit_effect(Color(1, 1, 1, 1), barrel.global_position, 10)
	EventBus.arena_spawn.emit(bullet)
	can_shoot = false

func _physics_process(delta: float) -> void:
	fire_progress.value = shot_timer
	if shot_timer >= cooldown:
		can_shoot = true
	else:
		shot_timer += delta

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		var tween = create_tween()
		tween.tween_property(shoot_container, "modulate", Color(1, 1, 1, 1), 0.3)

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		var tween = create_tween()
		tween.tween_property(shoot_container, "modulate", Color(1, 1, 1, 0), 0.3)
