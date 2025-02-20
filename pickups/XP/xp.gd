extends Pickup

@onready var pickup_area: Area2D = $PickupArea

func _ready() -> void:
	speed = 150
	type = PickupType.XP
	pickup_distance = 25
	area_entered.connect(_on_area_entered)
	pickup_area.area_entered.connect(_pickup_range_entered)
	
func on_pickup() -> void:
	GameState.xp += 1
	queue_free()
