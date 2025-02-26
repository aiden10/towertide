extends Node

var unique_items: Dictionary = {}
var shop_items: Dictionary = {}
var all_items: Dictionary = {}

## Unique items
const REGEN_IMAGE_PATH: String = "res://sprites/items/regen_potion.png"
const REGEN_NAME: String = "Regeneration Potion"
const REGEN_DESCRIPTION: String = "Regenerate faster"
const REGEN_PRICE: int = 5
const REGEN_COOLDOWN_DECREASE: int = 5

const SWORD_IMAGE_PATH: String = "res://sprites/items/sword.png"
const SWORD_NAME: String = "Sword"
const SWORD_DESCRIPTION: String = "Deflect enemy bullets and deal melee damage"
const SWORD_PRICE: int = 5
const SWORD_DAMAGE: float = 5

## Shop items
const STEROIDS_IMAGE_PATH: String = "res://sprites/items/shop_items/shop_item_template.png"
const STEROIDS_NAME: String = "Steroids"
const STEROIDS_DESCRIPTION: String = "+2 Damage, -5 Max Health"
const STEROIDS_PRICE: int = 5
const STEROIDS_DAMAGE_INCREASE: int = 2
const STEROIDS_HEALTH_DECREASE: int = 5

func _init() -> void:
	unique_items[REGEN_NAME] = RegenPotion.new()
	unique_items[SWORD_NAME] = Sword.new()
	shop_items[STEROIDS_NAME] = Steroids.new()
	for item in unique_items.values() + shop_items.values():
		all_items[item.item_name] = item
