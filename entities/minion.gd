extends Entity
class_name Minion

var tower: Tower
var minion_name: String
var wander_distance: float
var min_wander: float
var detected_enemy: Enemy
var despawn_timer: Timer
var death_tween: Tween
var bullet_scale: float = 1.0

func _init() -> void:
	EventBus.minion_spawned.emit()
	collision_layer = 0
	collision_mask = 0

func use_item(_delta: float) -> void:
	pass

func _on_death() -> void:
	if death_tween:
		death_tween.kill()

	death_tween = create_tween()
	death_tween.set_parallel(true)
	death_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0).set_ease(Tween.EASE_IN)
	death_tween.tween_property(self, "position", position + Vector2(0, -20), 1.0).set_ease(Tween.EASE_OUT)
	death_tween.tween_property(self, "rotation", rotation + randf_range(-PI/2, PI/2), 1.0)
	Utils.spawn_hit_effect(Color8(255, 255, 255, 255), global_position, damage)
	death_tween.chain().tween_callback(queue_free)
