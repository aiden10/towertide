extends Pickup

func _ready() -> void:
	super._ready()
	
	speed = PlayerState.speed * 1.1 # Always 10% faster  
	type = PickupType.GOLD
	pickup_distance = 5
	
	if has_node("PickupArea"):
		var pickup_area = $PickupArea
		pickup_area.area_entered.connect(_on_area_entered)

func on_pickup() -> void:
	EventBus.gold_picked_up.emit()
	queue_free()
