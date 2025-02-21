extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		door_entered()

func door_entered() -> void:
	queue_free()
	EventBus.level_clear.emit()
