extends Pickup

@onready var pickup_area: Area2D = $PickupArea

func _ready() -> void:
	speed = 150
	type = PickupType.GOLD
	pickup_distance = 25
	area_entered.connect(_on_area_entered)
	pickup_area.area_entered.connect(_pickup_range_entered)
	
func on_pickup() -> void:
	EventBus.gold_picked_up.emit()
	queue_free()
