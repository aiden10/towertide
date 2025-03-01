extends Item

class_name CreditCard

func _init() -> void:
	item_name = Items.CREDIT_CARD_NAME
	description = Items.CREDIT_CARD_DESCRIPTION
	price = Items.CREDIT_CARD_PRICE
	image_path = Items.CREDIT_CARD_IMAGE_PATH
	image = load(image_path)

func on_aquire() -> void:
	EventBus._item_aquired.emit()
	PlayerState.minimum_gold += Items.CREDIT_CARD_LIMIT

func use(_delta: float) -> void:
	pass
