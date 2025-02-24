extends MarginContainer

@onready var row1: HBoxContainer = $Row1
@onready var row2: HBoxContainer = $Row2
@export var max_row_length: int = 8

func _ready() -> void:
	EventBus.arena_initialized.connect(update_overlay)

func update_overlay() -> void:
	for child_node in row1.get_children() + row2.get_children():
		child_node.queue_free()
	
	var i = 0
	var done_items = []
	for item in PlayerState.player_items:
		if item.item_name in done_items:
			continue
		
		var item_cell = Scenes.item_cell_scene.instantiate()
		if i < max_row_length:
			row1.add_child(item_cell)
		## Not sure how to handle if the player has more than 16 items
		elif i >= max_row_length and i < max_row_length * 2:
			row2.add_child(item_cell)
		item_cell.populate_cell(item, PlayerState.item_counts[item.item_name])
		i += 1
		done_items.append(item.item_name)
