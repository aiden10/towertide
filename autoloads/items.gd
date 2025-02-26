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

const MAGNET_IMAGE_PATH: String = "res://sprites/items/shop_items/shop_item_template.png"
const MAGNET_NAME: String = "Magnet"
const MAGNET_DESCRIPTION: String = "Pulls xp and gold towards you"
const MAGNET_PRICE: int = 5
const MAGNET_ATTRACT_SPEED: int = 80

## Shop items
const STEROIDS_IMAGE_PATH: String = "res://sprites/items/shop_items/shop_item_template.png"
const STEROIDS_NAME: String = "Steroids"
const STEROIDS_DESCRIPTION: String = "+2 Damage, -5 Max Health"
const STEROIDS_PRICE: int = 5
const STEROIDS_DAMAGE_INCREASE: int = 2
const STEROIDS_HEALTH_DECREASE: int = 5

const LIGHT_ROUNDS_IMAGE_PATH: String = "res://sprites/items/shop_items/shop_item_template.png"
const LIGHT_ROUNDS_NAME: String = "Light Rounds"
const LIGHT_ROUNDS_DESCRIPTION: String = "-2 Damage, +100 Bullet Speed"
const LIGHT_ROUNDS_PRICE: int = 5
const LIGHT_ROUNDS_DAMAGE_DECREASE: int = 2
const LIGHT_ROUNDS_SPEED_INCREASE: int = 100

func _init() -> void:
	unique_items[REGEN_NAME] = RegenPotion.new()
	unique_items[SWORD_NAME] = Sword.new()
	unique_items[MAGNET_NAME] = Magnet.new()
	shop_items[STEROIDS_NAME] = Steroids.new()
	shop_items[LIGHT_ROUNDS_NAME] = LightRounds.new()

	for item in unique_items.values() + shop_items.values():
		all_items[item.item_name] = item
