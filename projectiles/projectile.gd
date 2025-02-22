extends Area2D

var direction: Vector2
var velocity: Vector2
var speed: int 
var shooter: String
var damage: float
var lifetime: float = 4.0
var pierce: int = 0

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	scale_size(damage)

func start(mouse_position: Vector2, projectile_speed: int, bullet_damage: int, origin: String) -> void:	
	speed = projectile_speed
	damage = bullet_damage
	shooter = origin
	direction = (mouse_position - position).normalized()
	rotation = direction.angle()
	
	var tween = create_tween()
	tween.tween_interval(lifetime)
	tween.tween_callback(clear)
	
	if origin == "player":
		pierce = PlayerState.pierce

func clear() -> void:
	GameState.player_projectiles.erase(self)
	queue_free()

func scale_size(bullet_damage: float) -> void:
	var player_scale: float = 0
	if shooter == "player":
		player_scale = PlayerState.bullet_size
		
	hitbox.scale *= (log(bullet_damage) / 2) + player_scale
	sprite.scale *= (log(bullet_damage) / 2) + player_scale

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	position += velocity * delta

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Sword") and shooter != "player":
		direction *= -1
		shooter = "player"
		Utils.spawn_hit_effect(Color(255, 255, 255, 100), position, damage)
		return

	if parent.is_in_group("Enemies") and shooter != "enemy":
		Utils.spawn_hit_effect(Color(255, 255, 255, 50), position, damage)
		parent.take_damage(damage, direction)
		pierce -= 1
		if pierce <= 0:
			clear()

	if parent.is_in_group("Player") and shooter != "player":
		Utils.spawn_hit_effect(Color(255, 0, 0, 50), position, damage)
		parent.take_damage(damage)
		clear()
