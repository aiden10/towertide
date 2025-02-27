extends State
var charge_duration: float = 1.0
var charge_cooldown: float = 0.5
var timer: float = 0
var is_charging: bool = false
var charge_direction: Vector2 = Vector2.ZERO
var charge_speed_multiplier: float = 2.5

func enter() -> void:
	timer = charge_cooldown
	is_charging = false
	enemy.damage *= 1.5

func exit() -> void:
	enemy.damage /= 1.5

func physics_update(delta: float):
	timer -= delta
	
	if is_charging:
		# Continue charge in set direction
		enemy.velocity = charge_direction * enemy.speed * charge_speed_multiplier
		
		if timer <= 0:
			is_charging = false
			timer = charge_cooldown
			enemy.velocity = Vector2.ZERO
	else:
		# Prepare for charge
		if timer <= 0:
			# Telegraph the charge with a visual effect
			if enemy.has_method("telegraph_charge"):
				enemy.telegraph_charge()
				
			charge_direction = (GameState.player_position - enemy.global_position).normalized()
			is_charging = true
			timer = charge_duration
		else:
			# Slight movement toward player while preparing
			var direction = GameState.player_position - enemy.global_position
			enemy.velocity = direction.normalized() * enemy.speed * 0.3
			
	# Exit state if player is too far
	var distance_to_player = enemy.global_position.distance_to(GameState.player_position)
	if distance_to_player > enemy.distance_threshold / 2 and !is_charging:
		transitioned.emit(self, "follow")
