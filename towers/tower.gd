extends Area2D

class_name Tower

var cooldown: float
var tower_name: String
var cost: int
var damage: float
var kills: int
var image: Texture

## Tower upgrades
var upgrade1_name: String
var upgrade2_name: String
var upgrade3_name: String

var upgrade1_price: int
var upgrade2_price: int
var upgrade3_price: int

var upgrade1_image: Texture
var upgrade2_image: Texture
var upgrade3_image: Texture

var upgrade1_scene: PackedScene
var upgrade2_scene: PackedScene
var upgrade3_scene: PackedScene

func _init() -> void:
	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exit)
	input_event.connect(_on_input_event)
	EventBus.tower_selected.connect(_on_mouse_exit)

func upgrade(new_tower_scene: PackedScene) -> void:
	var new_tower = new_tower_scene.instantiate()
	EventBus.arena_spawn.emit(new_tower)
	queue_free()
	
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
	$Sprite.modulate = Color8(255, 500, 255, 100)

func deselect_tower() -> void:
	EventBus.tower_deselected.emit()
	$Sprite.modulate = Color8(255, 255, 255, 255)
	GameState.selected_tower = null
