extends State
var minion_attack_range: Area2D
var destination: Vector2
var direction: Vector2
var follow_timer: float = 0
var max_follow_time: float = 5.0

func enter() -> void:
	minion.speed *= 3 
	minion_attack_range = get_attack_range()
	if minion_attack_range.area_entered.is_connected(detected):
		minion_attack_range.area_entered.disconnect(detected)
	minion_attack_range.area_entered.connect(detected)
	follow_timer = 0 
	
func exit() -> void:
	if minion_attack_range.area_entered.is_connected(detected):
		minion_attack_range.area_entered.disconnect(detected)
	minion.speed /= 3
	
func on_death() -> void:
	for attackable_area in minion_attack_range.get_overlapping_areas():
		if is_instance_valid(attackable_area) and is_instance_valid(attackable_area.get_parent()):
			var parent = attackable_area.get_parent()
			if parent.is_in_group("Enemies"):
				var attackable_enemy: Enemy = parent
				attackable_enemy.take_damage(PlayerState.damage * minion.damage, minion.tower)
				minion.modulate = Color8(510, 255, 255, 255)
				Utils.spawn_hit_effect(Color8(255, 255, 255, 255), minion.global_position, PlayerState.damage * minion.damage)
				minion.queue_free()
				EventBus.minion_died.emit()

func detected(area: Area2D) -> void:
	if !is_instance_valid(area) || !is_instance_valid(area.get_parent()):
		return
		
	var parent = area.get_parent()	
	if parent.is_in_group("Enemies") and not parent.is_in_group("Stealth"):
		if minion.minion_name == Towers.CHARGER_NAME:
			on_death()
		elif minion.minion_name == Towers.KIDNAPPER_NAME:
			if parent == minion.detected_enemy:
				transitioned.emit(self, "return")

func physics_update(delta: float) -> void:
	follow_timer += delta
	
	if follow_timer > max_follow_time:
		transitioned.emit(self, "idle")
		return
	
	if not is_instance_valid(minion.detected_enemy):
		transitioned.emit(self, "idle")
		return
	
	destination = minion.detected_enemy.global_position
	direction = destination - minion.global_position
	
	if direction.length() < 50:
		# Check if the enemy is actually in attack range
		var enemy_in_range = false
		for area in minion_attack_range.get_overlapping_areas():
			if is_instance_valid(area) and is_instance_valid(area.get_parent()):
				var parent = area.get_parent()
				if parent == minion.detected_enemy:
					enemy_in_range = true
					break
		
		if enemy_in_range and minion.minion_name == Towers.KIDNAPPER_NAME:
			transitioned.emit(self, "return")
			return
	
	minion.velocity = direction.normalized() * minion.speed
	minion.look_at(destination)
