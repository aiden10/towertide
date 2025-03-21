extends Node

@export var initial_state: State
signal state_changed(state_name)
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	var parent = get_parent()
	for child in get_children():
		if child is State:
			if parent.is_in_group("Enemies"):
				child.setup_enemy(parent)
			if parent.is_in_group("Minions"):
				child.setup_minion(parent)
				
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transition)
	
	if initial_state:
		current_state = initial_state
		current_state.enter()
		
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _on_child_transition(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	
	var new_state = states[new_state_name.to_lower()]
	if not new_state:
		return

	current_state.exit()
	current_state = new_state
	current_state.enter()
	state_changed.emit(current_state.name.to_lower())
