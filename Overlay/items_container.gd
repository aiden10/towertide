extends MarginContainer
@onready var items_container: VBoxContainer = $VBoxContainer/ScrollBox/VBoxContainer

func _ready() -> void:
	EventBus._item_aquired.connect(update_overlay)
	update_overlay()

func update_overlay() -> void:
	for child_node in items_container.get_children():
		child_node.queue_free()

	if PlayerState.player_items.size() == 0:
		return
	
	var done_items = []
	for item in PlayerState.player_items:
		if item.item_name in done_items:
			continue
		
		var item_cell = Scenes.item_cell_scene.instantiate()
		items_container.add_child(item_cell)
		
		item_cell.size_flags_horizontal = Control.SIZE_FILL
		item_cell.size_flags_vertical = Control.SIZE_FILL
		item_cell.custom_minimum_size = Vector2(100, 80)
		
		done_items.append(item.item_name)
		
		item_cell.populate_cell(item, PlayerState.item_counts[item.item_name])
