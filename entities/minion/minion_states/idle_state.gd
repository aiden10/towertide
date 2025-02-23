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

func exit() -> void:
	minion_detection_range.area_entered.disconnect(detected)

func detected(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemies"):
		minion.detected_enemy = parent
		transitioned.emit(self, "follow")

func physics_update(delta: float) -> void:
	if minion.global_position.distance_to(destination) < 15:
		destination = Utils.get_random_position_in_radius(tower_position, minion.wander_distance, minion.min_wander)
	
	direction = destination - minion.global_position
	minion.velocity = direction.normalized() * minion.speed
