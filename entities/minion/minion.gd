extends Entity

class_name Minion

var tower: Tower
var wander_distance: float
var min_wander: float
var detected_enemy: Enemy
var despawn_timer: Timer

func _init() -> void:
	despawn_timer = Timer.new()
	add_child(despawn_timer)
	despawn_timer.wait_time = Towers.MINION_LIFETIME
	despawn_timer.one_shot = true
	despawn_timer.timeout.connect(queue_free)
	despawn_timer.autostart = true
	collision_layer = 0
	collision_mask = 0

func use_item(delta: float) -> void:
	pass
