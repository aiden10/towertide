extends Node

var all_items: Array[Item] = []
 
const REGEN_IMAGE_PATH: String = "res://sprites/items/regen_potion.png"
const REGEN_NAME: String = "Regeneration Potion"
const REGEN_DESCRIPTION: String = "Regenerate 1HP every 5 seconds"
const REGEN_PRICE: int = 5
const REGEN_COOLDOWN: float = 30

func _init() -> void:
	all_items.append(RegenPotion.new())
