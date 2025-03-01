extends Control

@onready var gold_label: Label = $CanvasLayer/StatusContainer/GoldContainer/GoldLabel
@onready var clear_condition_label: Label = $CanvasLayer/ClearConditionContainer/VBoxContainer/ClearConditionLabel
@onready var stage_label: Label = $CanvasLayer/ClearConditionContainer/VBoxContainer/StageLabel
@onready var xp_label: Label = $CanvasLayer/XPContainer/VBoxContainer/XPLabel
@onready var xp_bar: ProgressBar = $CanvasLayer/XPContainer/VBoxContainer/XPBar

@onready var cross_container: PanelContainer = $CanvasLayer/TowersContainer/HBoxContainer/CrossContainer/PanelContainer
@onready var cross_cost_label: Label = $CanvasLayer/TowersContainer/HBoxContainer/CrossContainer/HBoxContainer/CrossCostLabel
@onready var key_label1: Label = $CanvasLayer/TowersContainer/HBoxContainer/CrossContainer/KeyLabel1
@onready var cross_image: TextureRect = $CanvasLayer/TowersContainer/HBoxContainer/CrossContainer/PanelContainer/CrossImage
@onready var cross_name_info: Label = $CanvasLayer/Descriptions/Cross/VBoxContainer/CrossNameInfo
@onready var cross_description_info: Label = $CanvasLayer/Descriptions/Cross/VBoxContainer/CrossDescriptionInfo
@onready var cross_info_panel: PanelContainer = $CanvasLayer/Descriptions/Cross
@onready var sprayer_count: Label = $CanvasLayer/TowersContainer/HBoxContainer/CrossContainer/PanelContainer/CrossCount

@onready var sentry_container: PanelContainer = $CanvasLayer/TowersContainer/HBoxContainer/SentryContainer/PanelContainer
@onready var sentry_cost_label: Label = $CanvasLayer/TowersContainer/HBoxContainer/SentryContainer/HBoxContainer/SentryCostLabel
@onready var key_label2: Label = $CanvasLayer/TowersContainer/HBoxContainer/SentryContainer/KeyLabel2
@onready var sentry_image: TextureRect = $CanvasLayer/TowersContainer/HBoxContainer/SentryContainer/PanelContainer/SentryImage
@onready var sentry_name_info: Label = $CanvasLayer/Descriptions/Sentry/VBoxContainer/SentryNameInfo
@onready var sentry_description_info: Label = $CanvasLayer/Descriptions/Sentry/VBoxContainer/SentryDescriptionInfo
@onready var sentry_info_panel: PanelContainer = $CanvasLayer/Descriptions/Sentry
@onready var sentry_count: Label = $CanvasLayer/TowersContainer/HBoxContainer/SentryContainer/PanelContainer/MarginContainer/SentryCount

@onready var spawner_container: PanelContainer = $CanvasLayer/TowersContainer/HBoxContainer/SpawnerContainer/PanelContainer
@onready var spawner_cost_label: Label = $CanvasLayer/TowersContainer/HBoxContainer/SpawnerContainer/HBoxContainer/SpawnerCostLabel
@onready var key_label3: Label = $CanvasLayer/TowersContainer/HBoxContainer/SpawnerContainer/KeyLabel3
@onready var spawner_image: TextureRect = $CanvasLayer/TowersContainer/HBoxContainer/SpawnerContainer/PanelContainer/SpawnerImage
@onready var spawner_name_info: Label = $CanvasLayer/Descriptions/Spawner/VBoxContainer/SpawnerNameInfo
@onready var spawner_description_info: Label = $CanvasLayer/Descriptions/Spawner/VBoxContainer/SpawnerDescriptionInfo
@onready var spawner_info_panel: PanelContainer = $CanvasLayer/Descriptions/Spawner
@onready var spawner_count: Label = $CanvasLayer/TowersContainer/HBoxContainer/SpawnerContainer/PanelContainer/SpawnerCount

@onready var blank_container: PanelContainer = $CanvasLayer/TowersContainer/HBoxContainer/BlankContainer/PanelContainer
@onready var blank_cost_label: Label = $CanvasLayer/TowersContainer/HBoxContainer/BlankContainer/HBoxContainer/BlankCostLabel
@onready var key_label4: Label = $CanvasLayer/TowersContainer/HBoxContainer/BlankContainer/KeyLabel4
@onready var blank_image: TextureRect = $CanvasLayer/TowersContainer/HBoxContainer/BlankContainer/PanelContainer/BlankImage
@onready var blank_name_info: Label = $CanvasLayer/Descriptions/Blank/VBoxContainer/BlankNameInfo
@onready var blank_description_info: Label = $CanvasLayer/Descriptions/Blank/VBoxContainer/BlankDescriptionInfo
@onready var blank_info_panel: PanelContainer = $CanvasLayer/Descriptions/Blank
@onready var blank_count: Label = $CanvasLayer/TowersContainer/HBoxContainer/BlankContainer/PanelContainer/BlankCount

@onready var arrow: TextureRect = $CanvasLayer/Arrow
@onready var spawn_bar: ProgressBar = $CanvasLayer/ClearConditionContainer/VBoxContainer/SpawnBar
@onready var spawning_label: Label = $CanvasLayer/ClearConditionContainer/VBoxContainer/SpawningLabel

@onready var boss_stage_indicator: MarginContainer = $CanvasLayer/BossStageIndicator
@onready var boss_label: Label = $CanvasLayer/BossStageIndicator/StagesUntilBossLabel

var pulse_tween: Tween = null
var stages_until_boss: int

func _ready() -> void:	
	EventBus.tower1_selected.connect(func(): reset_modulation(); cross_image.modulate = Color8(255, 255, 255, 50))
	EventBus.tower1_deselected.connect(func(): reset_modulation(); cross_image.modulate = Color8(255, 255, 255, 150))
	EventBus.tower2_selected.connect(func(): reset_modulation(); sentry_image.modulate = Color8(255, 255, 255, 50))
	EventBus.tower2_deselected.connect(func(): reset_modulation(); sentry_image.modulate = Color8(255, 255, 255, 150))
	EventBus.tower3_selected.connect(func(): reset_modulation(); spawner_image.modulate = Color8(255, 255, 255, 50))
	EventBus.tower3_deselected.connect(func(): reset_modulation(); spawner_image.modulate = Color8(255, 255, 255, 150))
	EventBus.tower4_selected.connect(func(): reset_modulation(); blank_image.modulate = Color8(255, 255, 255, 50))
	EventBus.tower4_deselected.connect(func(): reset_modulation(); blank_image.modulate = Color8(255, 255, 255, 150))
	
	EventBus.door_visible.connect(func(): arrow.visible = true)
	EventBus.door_not_visible.connect(func(): arrow.visible = false)
	EventBus.update_spawning_bar.connect(_update_spawn_progress)
		
	cross_cost_label.text = str(Towers.CROSS_COST)
	key_label1.text = Utils.get_action_key_name("place_tower1")
	cross_name_info.text = Towers.CROSS_NAME
	cross_description_info.text = Towers.CROSS_DESCRIPTION
	
	sentry_cost_label.text = str(Towers.SENTRY_COST)
	key_label2.text = Utils.get_action_key_name("place_tower2")
	sentry_name_info.text = Towers.SENTRY_NAME
	sentry_description_info.text = Towers.SENTRY_DESCRIPTION

	spawner_cost_label.text = str(Towers.SPAWNER_COST)
	key_label3.text = Utils.get_action_key_name("place_tower3")
	spawner_name_info.text = Towers.SPAWNER_NAME
	spawner_description_info.text = Towers.SPAWNER_DESCRIPTION

	blank_cost_label.text = str(Towers.BLANK_COST)
	key_label4.text = Utils.get_action_key_name("place_tower4")
	blank_name_info.text = Towers.BLANK_NAME
	blank_description_info.text = Towers.BLANK_DESCRIPTION
	
	stage_label.text = "Stage " + str(GameState.stage)
	
	cross_container.mouse_entered.connect(_on_cross_container_mouse_entered)
	cross_container.mouse_exited.connect(_on_cross_container_mouse_exited)
	
	sentry_container.mouse_entered.connect(_on_sentry_container_mouse_entered)
	sentry_container.mouse_exited.connect(_on_sentry_container_mouse_exited)
	
	spawner_container.mouse_entered.connect(_on_spawner_container_mouse_entered)
	spawner_container.mouse_exited.connect(_on_spawner_container_mouse_exited)
	
	blank_container.mouse_entered.connect(_on_blank_container_mouse_entered)
	blank_container.mouse_exited.connect(_on_blank_container_mouse_exited)

	cross_container.gui_input.connect(_on_cross_container_gui_input)
	sentry_container.gui_input.connect(_on_sentry_container_gui_input)
	spawner_container.gui_input.connect(_on_spawner_container_gui_input)
	blank_container.gui_input.connect(_on_blank_container_gui_input)
	
	if not GameState.is_boss_stage:
		boss_stage_indicator.visible = true
		boss_label.visible = true
		stages_until_boss = GameState.boss_stage_increment - (GameState.stage % GameState.boss_stage_increment)
		boss_label.text = "Stages Until Boss: " + str(stages_until_boss)
		
func _on_cross_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		accept_event()
		if PlayerState.sprayer_limit > 0:
			EventBus.toggle_tower_selection.emit(1, Towers.CROSS_COST, EventBus.tower1_selected)
		else:
			EventBus.invalid_action.emit()
			
func _on_sentry_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		accept_event()
		if PlayerState.sentry_limit > 0:
			EventBus.toggle_tower_selection.emit(2, Towers.SENTRY_COST, EventBus.tower2_selected)
		else:
			EventBus.invalid_action.emit()
			
func _on_spawner_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		accept_event()
		if PlayerState.spawner_limit > 0:
			EventBus.toggle_tower_selection.emit(3, Towers.SPAWNER_COST, EventBus.tower3_selected)
		else:
			EventBus.invalid_action.emit()
			
func _on_blank_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		accept_event()
		if PlayerState.blank_limit > 0:
			EventBus.toggle_tower_selection.emit(4, Towers.BLANK_COST, EventBus.tower4_selected)
		else:
			EventBus.invalid_action.emit()
			
func _on_cross_container_mouse_entered() -> void:
	cross_info_panel.visible = true
	reset_modulation()
	cross_image.modulate = Color8(255, 255, 255, 50)
	
func _on_cross_container_mouse_exited() -> void:
	cross_info_panel.visible = false
	reset_modulation()
	cross_image.modulate = Color8(255, 255, 255, 150)

func _on_sentry_container_mouse_entered() -> void:
	sentry_info_panel.visible = true
	reset_modulation()
	sentry_image.modulate = Color8(255, 255, 255, 50)
	
func _on_sentry_container_mouse_exited() -> void:
	sentry_info_panel.visible = false
	reset_modulation()
	sentry_image.modulate = Color8(255, 255, 255, 150)

func _on_spawner_container_mouse_entered() -> void:
	spawner_info_panel.visible = true
	reset_modulation()
	spawner_image.modulate = Color8(255, 255, 255, 50)
	
func _on_spawner_container_mouse_exited() -> void:
	spawner_info_panel.visible = false
	reset_modulation()
	spawner_image.modulate = Color8(255, 255, 255, 150)

func _on_blank_container_mouse_entered() -> void:
	blank_info_panel.visible = true
	reset_modulation()
	blank_image.modulate = Color8(255, 255, 255, 50)
	
func _on_blank_container_mouse_exited() -> void:
	blank_info_panel.visible = false
	reset_modulation()
	blank_image.modulate = Color8(255, 255, 255, 150)
	
func reset_modulation() -> void:
	sentry_image.modulate = Color8(255, 255, 255, 150)
	cross_image.modulate = Color8(255, 255, 255, 150)
	spawner_image.modulate = Color8(255, 255, 255, 150)

func _update_spawn_progress(progress: float, enemies_to_spawn: int, time_scale: float) -> void:
	if GameState.level_cleared:
		spawning_label.visible = true
		spawn_bar.max_value = time_scale
		spawn_bar.value = progress
		spawning_label.text = "Spawning " + str(enemies_to_spawn - 1) + " extra enemies"
		if enemies_to_spawn == 2:
			spawning_label.text = "Spawning " + str(enemies_to_spawn - 1) + " extra enemy"

func _process(_delta: float) -> void:
	gold_label.text = str(PlayerState.gold)
	xp_label.text = str(PlayerState.xp) + " / " + str(PlayerState.level_up_condition)
	xp_bar.max_value = PlayerState.level_up_condition
	xp_bar.value = PlayerState.xp
	
	sprayer_count.text = str(PlayerState.sprayer_limit)
	sentry_count.text = str(PlayerState.sentry_limit)
	spawner_count.text = str(PlayerState.spawner_limit)
	blank_count.text = str(PlayerState.blank_limit)
	
	## Wave started but not yet cleared
	if not GameState.level_cleared and GameState.wave_started:
		if GameState.is_boss_stage:
			clear_condition_label.text = "Kill the boss to proceed"
		else:
			clear_condition_label.text = "Kill " + str(GameState.clear_condition) + " enemies to proceed"
			spawn_bar.max_value = GameState.clear_condition
			spawn_bar.value = GameState.enemies_killed_this_stage
		
		if pulse_tween and pulse_tween.is_valid():
			pulse_tween.kill()
			pulse_tween = null
			clear_condition_label.modulate = Color(1, 1, 1, 1)  # Reset opacity

	## Wave not started and level not cleared
	elif not GameState.level_cleared and not GameState.wave_started:
		var start_text: String
		if GameState.is_boss_stage:
			start_text = " to summon the boss"
		else:
			start_text = " to start the wave"
		clear_condition_label.text = "Press " + Utils.get_action_key_name("start_wave") + start_text

		if not pulse_tween or not pulse_tween.is_valid():
			pulse_tween = create_tween()
			pulse_tween.set_loops(-1)
			pulse_tween.tween_property(clear_condition_label, "modulate", Color(1, 1, 1, 0), 2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
			pulse_tween.tween_property(clear_condition_label, "modulate", Color(1, 1, 1, 1), 2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

	## Level cleared
	elif GameState.level_cleared and GameState.wave_started:
		clear_condition_label.text = "Enter the door to proceed to the shop"

		if pulse_tween and pulse_tween.is_valid():
			pulse_tween.kill()
			pulse_tween = null
			clear_condition_label.modulate = Color(1, 1, 1, 1)  # Reset opacity

	var direction = GameState.door_position - GameState.player_position
	var angle = atan2(direction.y, direction.x)
	arrow.rotation_degrees = rad_to_deg(angle) + 180
