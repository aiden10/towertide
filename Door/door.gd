extends Area2D

@onready var enter_container: PanelContainer = $PanelContainer
@onready var enter_label: Label = $PanelContainer/EnterLabel
var can_enter: bool = false

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	GameState.door_position = global_position
	enter_container.modulate = Color(1, 1, 1, 0)
	enter_label.text = "Press " + Utils.get_action_key_name("enter") + " to enter" 

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter") and can_enter:
		door_entered()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		can_enter = true
		var tween = create_tween()
		tween.tween_property(enter_container, "modulate", Color(1, 1, 1, 1), 0.3)

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		can_enter = false
		var tween = create_tween()
		tween.tween_property(enter_container, "modulate", Color(1, 1, 1, 0), 0.3)

func door_entered() -> void:
	queue_free()
	EventBus.level_exited.emit()
