extends Control

@onready var item_icon: TextureRect = $MarginContainer/VBoxContainer/ItemIcon
@onready var quantity_label: Label = $MarginContainer/VBoxContainer/QuantityLabel
@onready var item_name_label: Label = $InfoContainer/PanelContainer/MarginContainer/VBoxContainer/ItemName
@onready var item_description: Label = $InfoContainer/PanelContainer/MarginContainer/VBoxContainer/ItemDescription
@onready var info_container: MarginContainer = $InfoContainer

func _ready() -> void:
	mouse_entered.connect(func(): info_container.visible = true)
	mouse_exited.connect(func(): info_container.visible = false)
	info_container.visible = false
	
func populate_cell(item: Item, quantity: int) -> void:
	item_icon.texture = item.image
	item_name_label.text = item.item_name
	item_description.text = item.description
	quantity_label.text = str(quantity)
	
