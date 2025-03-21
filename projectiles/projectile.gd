extends Area2D

var direction: Vector2
var velocity: Vector2
var speed: int 
var shooter_id: int  # Store just the instance ID instead of duplicating
var shooter_groups: Array[StringName]
var damage: float
var lifetime: float = 4.0
var pierce: int = 0
var is_offscreen: bool = false
var projectile_scale: float = 1.0

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D
var despawn_timer: Timer

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	scale_size(damage)

func start(mouse_position: Vector2, projectile_speed: int, bullet_damage: int, origin: Node, bullet_scale: float = 0.5, extra_pierce: int = 0) -> void:    
	speed = projectile_speed
	damage = bullet_damage
	projectile_scale = bullet_scale
	pierce += extra_pierce
	shooter_id = origin.get_instance_id()
	shooter_groups = origin.get_groups()
	
	direction = (mouse_position - position).normalized()
	rotation = direction.angle()
	
	despawn_timer = Timer.new()
	add_child(despawn_timer)
	despawn_timer.wait_time = lifetime
	despawn_timer.one_shot = true
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	
	if "Enemies" not in shooter_groups:
		pierce += PlayerState.pierce

func get_shooter() -> Node:
	return instance_from_id(shooter_id) if shooter_id else null

func clear() -> void:
	GameState.player_projectiles.erase(self)
	queue_free()

func scale_size(bullet_damage: float) -> void:
	var extra_scale: float = 0
	if "Player" in shooter_groups or "Towers" in shooter_groups:
		extra_scale = PlayerState.bullet_size
	elif "Enemies" in shooter_groups:
		extra_scale = -0.5
	scale *= projectile_scale
	scale *= max(1, log(bullet_damage / 5) + extra_scale)

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	position += velocity * delta
	
	var camera = get_viewport().get_camera_2d()
	if camera:
		var viewport_rect = get_viewport_rect() 
		var world_rect = Rect2(camera.position - (viewport_rect.size / 2), viewport_rect.size)
		if not world_rect.has_point(position):
			if not is_offscreen:
				is_offscreen = true
				despawn_timer.start()
		else:
			if is_offscreen:
				is_offscreen = false
				despawn_timer.stop()

func _on_despawn_timer_timeout() -> void:
	clear()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	
	# Enemy bullet entered sword
	if parent.is_in_group("FriendlyDeflectors") and "Enemies" in shooter_groups:
		direction *= -1
		speed *= 1.5
		shooter_groups.append("Player")
		shooter_groups.remove_at(shooter_groups.find("Enemies"))
		Utils.spawn_hit_effect(Color(255, 255, 255, 100), position, damage)
		EventBus.deflect.emit()
		return

	## Friendly bullet enters enemy deflector
	if parent.is_in_group("EnemyDeflectors") and ("Player" in shooter_groups or "Towers" in shooter_groups):
		direction *= -1
		shooter_groups.append("Enemies")
		if "Player" in shooter_groups:
			shooter_groups.remove_at(shooter_groups.find("Player"))
		if "Towers" in shooter_groups:
			shooter_groups.remove_at(shooter_groups.find("Towers"))
		self.modulate = Color(2, 1, 1, 0.5)
		Utils.spawn_hit_effect(Color(255, 255, 255, 100), position, damage)
		EventBus.deflect.emit()
		return

	# Enemy bullet entered player
	if parent.is_in_group("Player") and "Enemies" in shooter_groups:
		Utils.spawn_hit_effect(Color(255, 0, 0, 50), position, damage)
		parent.take_damage(damage)
		clear()

	# Friendly bullet entered enemy
	if parent.is_in_group("Enemies") and not "Enemies" in shooter_groups:
		Utils.spawn_hit_effect(Color(255, 255, 255, 50), position, damage)
		parent.take_damage(damage, get_shooter(), direction)
		pierce -= 1
		if pierce <= 0:
			clear()
