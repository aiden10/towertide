extends Control

@onready var purchase_button: Button = $VBoxContainer/PanelContainer/PurchaseButton
@onready var item_image: TextureRect = $PanelContainer/MarginContainer/ItemImage
@onready var price_label: Label = $VBoxContainer/CenterContainer/HBoxContainer/PriceLabel
@onready var name_label: Label = $Name
@onready var description_label: Label = $VBoxContainer/Description

var item: Item
var maxed: bool = false

func _ready() -> void:
	EventBus.purchased.connect(check_limits)
	purchase_button.pressed.connect(_purchase_pressed)

func _purchase_pressed() -> void:
	if PlayerState.gold >= item.price and not maxed:
		PlayerState.gold -= item.price
		PlayerState.player_items.append(item.duplicate())
		if item.item_name in PlayerState.item_counts:
			PlayerState.item_counts[item.item_name] += 1
		else:
			PlayerState.item_counts[item.item_name] = 1
		if item.item_name == Items.SWORD_NAME:
			EventBus.sword_purchased.emit()
		EventBus.purchased.emit()
		queue_free()
	else:
		EventBus.invalid_action.emit()

func check_limits() -> void:
	if item.item_name == Items.SWORD_NAME:
		if item.item_name in PlayerState.item_counts:
			if PlayerState.item_counts[item.item_name] >= Items.SWORD_LIMIT:
				purchase_button.text = "MAX"
				maxed = true	

func populate() -> void:
	item_image.texture = item.image
	price_label.text = str(item.price)
	name_label.text = item.name
	description_label.text = item.description
	check_limits()
