extends Area2D

class_name Tower

var base_type: int
var tower_name: String
var description: String
var cost: int
var value: int
var cooldown: float
var shot_timer: float
var damage_scale: float
var bullet_scale: float = 0.5
var bullet_speed: float = 1.0
var kills: int
var image: Texture
var scene_path: String

## Tower upgrades
var upgrade1_name: String
var upgrade2_name: String
var upgrade3_name: String

var upgrade1_description: String
var upgrade2_description: String
var upgrade3_description: String

var upgrade1_price: int
var upgrade2_price: int
var upgrade3_price: int

var upgrade1_image: Texture
var upgrade2_image: Texture
var upgrade3_image: Texture

var upgrade1_scene: PackedScene
var upgrade2_scene: PackedScene
var upgrade3_scene: PackedScene

signal killed_enemy

func _init() -> void:
	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exit)
	input_event.connect(_on_input_event)
	killed_enemy.connect(func(): kills += 1)
	EventBus.tower_selected.connect(_on_mouse_exit)

func upgrade(new_tower_scene: PackedScene) -> void:
	var new_tower = new_tower_scene.instantiate()
	EventBus.arena_spawn.emit(new_tower)
	queue_free()

func add_value(previous_value: int) -> void:
	value += previous_value

func sell() -> void:
	EventBus.unselect_pressed.emit()
	if value % 2 != 0:
		PlayerState.gold += int((value + 1) / 2)
	else:
		PlayerState.gold += int(value / 2)

	if base_type == 1:
		PlayerState.sprayer_count -= 1
	elif base_type == 2:
		PlayerState.sentry_count -= 1
	elif base_type == 3:
		PlayerState.spawner_count -= 1
	elif base_type == 4:
		PlayerState.blank_count -= 1
	EventBus.tower_sold.emit()
	call_deferred("queue_free")

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_tower_clicked()

## Highlight the selected tower
func _on_mouse_enter() -> void:
	if GameState.selected_tower != self:
		$Sprite.modulate = Color8(255, 255, 255, 150)

## Unhighlight the tower
func _on_mouse_exit() -> void:
	if GameState.selected_tower != self:
		$Sprite.modulate = Color8(255, 255, 255, 255)

func _on_tower_clicked() -> void:
	if GameState.selected_tower == self:
		deselect_tower()
		return

	GameState.selected_tower = self
	EventBus.tower_selected.emit()
	turn_green()

func deselect_tower() -> void:
	$Sprite.modulate = Color8(255, 255, 255, 255)
	GameState.selected_tower = null
	EventBus.unselect_pressed.emit()

func turn_green() -> void:
	$Sprite.modulate = Color8(255, 500, 255, 100)
