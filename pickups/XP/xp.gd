extends Pickup

func _ready() -> void:
	super._ready()
	speed = PlayerState.speed * 1.1 # Always 10% faster
	type = PickupType.XP
	var pulse_tween = create_tween()
	pulse_tween.set_loops(-1)
	pulse_tween.set_trans(Tween.TRANS_SINE) # Use sine transition for smooth pulsing
	pulse_tween.set_ease(Tween.EASE_IN_OUT) # Smooth both ways
	
	# First tween: expand and glow
	pulse_tween.tween_property($Sprite, "scale", Vector2(0.3, 0.3), 1.5)
	pulse_tween.parallel().tween_property($Sprite, "modulate", Color(2, 1, 2.5, 1), 1)
	
	# Second tween: contract and dim
	pulse_tween.tween_property($Sprite, "scale", Vector2(0.2, 0.2), 1.5)
	pulse_tween.parallel().tween_property($Sprite, "modulate", Color(1, 1, 1, 0.8), 1)

func on_pickup() -> void:
	EventBus.xp_picked_up.emit()
	queue_free()
