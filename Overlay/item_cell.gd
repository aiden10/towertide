extends Control
@onready var item_icon: TextureRect = $MarginContainer/VBoxContainer/ItemIcon
@onready var quantity_label: Label = $MarginContainer/VBoxContainer/QuantityLabel
@onready var item_name_label: Label = $InfoContainer/PanelContainer/MarginContainer/VBoxContainer/ItemName
@onready var item_description: Label = $InfoContainer/PanelContainer/MarginContainer/VBoxContainer/ItemDescription
@onready var info_container: MarginContainer = $InfoContainer

func _ready() -> void:
	size_flags_horizontal = SIZE_FILL
	size_flags_vertical = SIZE_FILL
	custom_minimum_size = Vector2(100, 80)
	
	item_icon.mouse_entered.connect(func(): info_container.visible = true)
	item_icon.mouse_exited.connect(func(): info_container.visible = false)
	info_container.visible = false

	$MarginContainer.visible = true

func populate_cell(item: Item, quantity: int) -> void:
	if item and item.image:
		item_icon.texture = item.image
		
	if item:
		item_name_label.text = item.item_name
		item_description.text = item.description
	
	quantity_label.text = str(quantity)
	
