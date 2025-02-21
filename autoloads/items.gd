extends Node

var all_items: Dictionary = {}
 
const REGEN_IMAGE_PATH: String = "res://sprites/items/regen_potion.png"
const REGEN_NAME: String = "Regeneration Potion"
const REGEN_DESCRIPTION: String = "Regenerate 1HP every 5 seconds"
const REGEN_PRICE: int = 5
const REGEN_COOLDOWN: float = 30

const SWORD_IMAGE_PATH: String = "res://sprites/items/sword.png"
const SWORD_NAME: String = "Sword"
const SWORD_DESCRIPTION: String = "Deflect enemy bullets"
const SWORD_PRICE: int = 5
const SWORD_DAMAGE: int = 15

func _init() -> void:
	all_items[REGEN_NAME] = RegenPotion.new()
	all_items[SWORD_NAME] = Sword.new()
