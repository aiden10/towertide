extends State

var destination: Vector2 = Vector2.ZERO
var tower_position: Vector2
var minion_detection_range: Area2D
var direction: Vector2

func enter() -> void:
	minion_detection_range = get_detection_range()
	minion_detection_range.area_entered.connect(detected)
	tower_position = minion.tower.global_position
	destination = Utils.get_random_position_in_radius(tower_position, minion.wander_distance, minion.min_wander)
	if minion.minion_name == Towers.PERSON_NAME:
		minion.rotation_degrees = 0
		minion.sprite.play("default")

func exit() -> void:
	minion_detection_range.area_entered.disconnect(detected)

func detected(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemies") and not parent.is_in_group("Stealth") and not parent.is_in_group("Bosses"):
		minion.detected_enemy = parent
		if minion.minion_name == Towers.CHARGER_NAME or minion.minion_name == Towers.KIDNAPPER_NAME:
			transitioned.emit(self, "follow")
		elif minion.minion_name == Towers.SHOOTER_NAME:
			transitioned.emit(self, "shoot")
		elif minion.minion_name == Towers.PERSON_NAME:
			transitioned.emit(self, "melee")
		elif minion.minion_name == Towers.DRIFTER_NAME:
			if randf() > 0.5:
				transitioned.emit(self, "shoot")
			else:
				transitioned.emit(self, "melee")
		return

func physics_update(_delta: float) -> void:
	if minion.global_position.distance_to(destination) < 15:
		destination = Utils.get_random_position_in_radius(tower_position, minion.wander_distance, minion.min_wander)
	direction = destination - minion.global_position
	minion.velocity = direction.normalized() * minion.speed
	if minion.minion_name != Towers.PERSON_NAME:
		minion.look_at(destination)
	else:
		if direction.x > 0:
			minion.sprite.flip_h = false
		elif direction.x < 0:
			minion.sprite.flip_h = true
	
	## For the kidnapper, constantly check the detection radius, not only on enter
	if minion.minion_name == Towers.KIDNAPPER_NAME and minion.global_position.distance_to(tower_position) > 50:
		var detected_enemies = []
		for area in minion_detection_range.get_overlapping_areas():
			var parent = area.get_parent()
			if parent.is_in_group("Enemies") and not parent.is_in_group("Stealth") and not parent.is_in_group("Bosses"):
				detected_enemies.append(parent)
		if detected_enemies.size() > 0:
			minion.detected_enemy = detected_enemies.pick_random()
			transitioned.emit(self, "follow")
			
