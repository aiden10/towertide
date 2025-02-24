extends State

var minion_attack_range: Area2D
var destination: Vector2
var direction: Vector2

func enter() -> void:
	minion.speed *= 10 ## Increase speed when enemy detected
	minion_attack_range = get_attack_range()
	minion_attack_range.area_entered.connect(detected)

func exit() -> void:
	minion_attack_range.area_entered.disconnect(detected)

func on_death() -> void:
	for attackable_area in minion_attack_range.get_overlapping_areas():
		if attackable_area.get_parent().is_in_group("Enemies"):
			var attackable_enemy: Enemy = attackable_area.get_parent()
			attackable_enemy.take_damage(PlayerState.damage * minion.damage, minion.tower)
			minion.modulate = Color8(510, 255, 255, 255)
			Utils.spawn_hit_effect(Color8(255, 255, 255, 255), minion.global_position, PlayerState.damage * minion.damage)
			minion.queue_free()
			EventBus.minion_died.emit()

func detected(area: Area2D) -> void:
	var parent = area.get_parent()
	
	## Close enough to the detected enemy
	if parent.is_in_group("Enemies"):
		on_death()

func physics_update(delta: float) -> void:
	if not minion.detected_enemy:
		transitioned.emit(self, "idle")
		return
	
	destination = minion.detected_enemy.global_position
	direction = destination - minion.global_position
	minion.velocity = direction.normalized() * minion.speed
