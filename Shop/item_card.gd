extends Control

@onready var purchase_button: Button = $VBoxContainer/PurchaseButton
@onready var item_image: TextureRect = $PanelContainer/MarginContainer/ItemImage
@onready var price_label: Label = $VBoxContainer/PriceLabel
@onready var name_label: Label = $Name
@onready var description_label: Label = $VBoxContainer/Description

var item: Item

func _ready() -> void:
	purchase_button.pressed.connect(_purchase_pressed)

func _purchase_pressed() -> void:
	if PlayerState.gold >= item.price:
		PlayerState.gold -= item.price
		PlayerState.player_items.append(item.duplicate())
		EventBus.purchased.emit()
		queue_free()

func populate() -> void:
	item_image.texture = item.image
	price_label.text = str(item.price) + " Gold"
	name_label.text = item.name
	description_label.text = item.description
	
