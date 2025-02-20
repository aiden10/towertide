extends CharacterBody2D

@export var projectile_scene: PackedScene
var firerate_cooldown = PlayerConstants.DEFAULT_FIRERATE
var firerate = firerate_cooldown
var can_shoot = true
var health = PlayerConstants.PLAYER_HEALTH
var damage = PlayerConstants.DEFAULT_DAMAGE

signal clicked

func _ready() -> void:
	clicked.connect(shoot)

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * PlayerConstants.PLAYER_SPEED
	if Input.is_action_pressed("click"):
		clicked.emit(get_global_mouse_position())

func _physics_process(delta):
	get_input()
	look_at(get_global_mouse_position())
	var collision = move_and_collide(velocity * delta)
	if collision:
		EventBus.collided.emit(collision.get_collider())
	if firerate > 0:
		firerate -= delta
	if firerate <= 0:
		can_shoot = true
		firerate = firerate_cooldown
		
func shoot(mouse_position: Vector2):
	if can_shoot:
		var bullet = projectile_scene.instantiate()
		bullet.position = position
		bullet.start(mouse_position, PlayerConstants.PROJECTILE_SPEED, damage, "player")
		EventBus.arena_spawn.emit(bullet)
		can_shoot = false

func take_damage(damage_taken: float):
	health -= damage_taken
