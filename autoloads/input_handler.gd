extends Node

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("cancel"):
		EventBus.unselect_pressed.emit()
		if GameState.selected_tower:
			if is_instance_valid(GameState.selected_tower):
				GameState.selected_tower.deselect_tower()
				GameState.selected_tower = null

	if Input.is_action_just_pressed("start_wave") and not GameState.wave_started:
		var current_scene = get_tree().current_scene
		if current_scene.name == "Arena":
			EventBus._wave_started.emit()
			GameState.wave_started = true
	
	if Input.is_action_just_pressed("place_tower1"):
		EventBus.toggle_tower_selection.emit(1, Towers.CROSS_COST, EventBus.tower1_selected)
	elif Input.is_action_just_pressed("place_tower2"):
		EventBus.toggle_tower_selection.emit(2, Towers.SENTRY_COST, EventBus.tower2_selected)
	elif Input.is_action_just_pressed("place_tower3"):
		EventBus.toggle_tower_selection.emit(3, Towers.SPAWNER_COST, EventBus.tower3_selected)
	elif Input.is_action_just_pressed("place_tower4"):
		EventBus.toggle_tower_selection.emit(4, Towers.BLANK_COST, EventBus.tower4_selected)
	
