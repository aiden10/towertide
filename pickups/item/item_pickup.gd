extends Pickup

var item
@onready var item_sprite: Sprite2D = $ItemSprite

func _init() -> void:
	if Items.unique_items.size() > 0:
		item = Items.unique_items.values().pick_random()

func _ready() -> void:
	super._ready()
	speed = PlayerState.speed * 1.1 # Always 10% faster  
	type = PickupType.ITEM
	pickup_distance = 5
	Items.unique_items.erase(item.item_name)
	item_sprite.texture = item.image
	var pulse_tween = create_tween()
	pulse_tween.set_loops(-1)
	pulse_tween.tween_property(self, "modulate", Color(1, 1, 1, 0.5), 2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	pulse_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func on_pickup() -> void:
	PlayerState.player_items.append(item)
	PlayerState.item_counts[item.item_name] = PlayerState.item_counts.get(item.item_name, 0) + 1
	item.on_aquire()
	queue_free()
