extends Node

var unique_items: Dictionary = {}
var shop_items: Dictionary = {}
var all_items: Dictionary = {}

## Unique items
const REGEN_IMAGE_PATH: String = "res://sprites/items/regen_potion.png"
const REGEN_NAME: String = "Regeneration Potion"
const REGEN_DESCRIPTION: String = "Regenerate faster"
const REGEN_PRICE: int = 5
const REGEN_COOLDOWN_DECREASE: int = 9

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

const SNEAKERS_IMAGE_PATH: String = "res://sprites/items/shop_items/shop_item_template.png"
const SNEAKERS_NAME: String = "Sneakers"
const SNEAKERS_DESCRIPTION: String = "+10 Speed"
const SNEAKERS_PRICE: int = 5
const SNEAKERS_SPEED_INCREASE: int = 2

const LIGHT_ROUNDS_IMAGE_PATH: String = "res://sprites/items/shop_items/shop_item_template.png"
const LIGHT_ROUNDS_NAME: String = "Light Rounds"
const LIGHT_ROUNDS_DESCRIPTION: String = "+100 Bullet Speed, -2 Damage"
const LIGHT_ROUNDS_PRICE: int = 5
const LIGHT_ROUNDS_DAMAGE_DECREASE: int = 2
const LIGHT_ROUNDS_SPEED_INCREASE: int = 100

const AP_ROUNDS_IMAGE_PATH: String = "res://sprites/items/shop_items/shop_item_template.png"
const AP_ROUNDS_NAME: String = "AP Rounds"
const AP_ROUNDS_DESCRIPTION: String = "+1 Pierce, -10% Firerate"
const AP_ROUNDS_PRICE: int = 5
const AP_ROUNDS_PIERCE_INCREASE: int = 1
const AP_ROUNDS_FIRERATE_DECREASE: float = 1.1

const PILLS_IMAGE_PATH: String = "res://sprites/items/shop_items/shop_item_template.png"
const PILLS_NAME: String = "Pills"
const PILLS_DESCRIPTION: String = "+15% to a random stat, -15% to a random stat"
const PILLS_PRICE: int = 10
const PILLS_PERCENT_DECREASE: float = 0.95
const PILLS_PERCENT_INCREASE: float = 1.15

const HORSE_PILLS_IMAGE_PATH: String = "res://sprites/items/shop_items/shop_item_template.png"
const HORSE_PILLS_NAME: String = "Horse Pills"
const HORSE_PILLS_DESCRIPTION: String = "+30% to a random stat, -30% to a random stat"
const HORSE_PILLS_PRICE: int = 15
const HORSE_PILLS_PERCENT_DECREASE: float = 0.70
const HORSE_PILLS_PERCENT_INCREASE: float = 1.30

func _init() -> void:
	unique_items[REGEN_NAME] = RegenPotion.new()
	unique_items[SWORD_NAME] = Sword.new()
	unique_items[MAGNET_NAME] = Magnet.new()
	shop_items[STEROIDS_NAME] = Steroids.new()
	shop_items[LIGHT_ROUNDS_NAME] = LightRounds.new()
	shop_items[PILLS_NAME] = Pills.new()
	shop_items[HORSE_PILLS_NAME] = HorsePills.new()
	shop_items[AP_ROUNDS_NAME] = APRounds.new()
	shop_items[SNEAKERS_NAME] = Sneakers.new()

	for item in unique_items.values() + shop_items.values():
		all_items[item.item_name] = item
