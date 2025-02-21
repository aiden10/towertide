extends Area2D

var direction: Vector2
var velocity: Vector2
var speed: int 
var shooter: String
var damage: float
var lifetime: float = 2.0
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func start(mouse_position: Vector2, projectile_speed: int, bullet_damage: int, origin: String) -> void:
	if origin == "player":
		GameState.player_projectiles.append(self)
	
	speed = projectile_speed
	damage = bullet_damage
	shooter = origin
	direction = (mouse_position - position).normalized()
	rotation = direction.angle()
	
	var tween = create_tween()
	tween.tween_interval(lifetime)
	tween.tween_callback(queue_free)

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	position += velocity * delta

func spawn_hit_effect(color: Color) -> void:
	var hit_effect = Scenes.hit_effect_scene.instantiate()
	get_tree().root.add_child(hit_effect)
	hit_effect.global_position = position
	hit_effect.set_color(color)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemies") and shooter != "enemy":
		spawn_hit_effect(Color(255, 255, 255, 100))
		parent.take_damage(damage)
		queue_free()

	if parent.is_in_group("Player") and shooter != "player":
		spawn_hit_effect(Color(255, 0, 0, 100))
		parent.take_damage(damage)
		queue_free()
