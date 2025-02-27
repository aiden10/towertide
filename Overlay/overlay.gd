extends Control

@onready var gold_label: Label = $CanvasLayer/StatusContainer/PanelContainer/MarginContainer/GridContainer/GoldLabel
@onready var health_label: Label = $CanvasLayer/StatusContainer/PanelContainer/MarginContainer/GridContainer/HealthLabel
@onready var kills_label: Label = $CanvasLayer/StatusContainer/PanelContainer/MarginContainer/GridContainer/KillsLabel
@onready var clear_condition_label: Label = $CanvasLayer/ClearConditionContainer/VBoxContainer/ClearConditionLabel
@onready var stage_label: Label = $CanvasLayer/ClearConditionContainer/VBoxContainer/StageLabel
@onready var xp_label: Label = $CanvasLayer/XPContainer/VBoxContainer/XPLabel
@onready var xp_bar: ProgressBar = $CanvasLayer/XPContainer/VBoxContainer/XPBar

@onready var cross_container: VBoxContainer = $CanvasLayer/TowersContainer/HBoxContainer/CrossContainer
@onready var cross_cost_label: Label = $CanvasLayer/TowersContainer/HBoxContainer/CrossContainer/HBoxContainer/CrossCostLabel
@onready var key_label1: Label = $CanvasLayer/TowersContainer/HBoxContainer/CrossContainer/KeyLabel1
@onready var cross_image: TextureRect = $CanvasLayer/TowersContainer/HBoxContainer/CrossContainer/PanelContainer/CrossImage

@onready var sentry_cost_label: Label = $CanvasLayer/TowersContainer/HBoxContainer/SentryContainer/HBoxContainer/SentryCostLabel
@onready var key_label2: Label = $CanvasLayer/TowersContainer/HBoxContainer/SentryContainer/KeyLabel2
@onready var sentry_image: TextureRect = $CanvasLayer/TowersContainer/HBoxContainer/SentryContainer/PanelContainer/SentryImage

@onready var spawner_container: VBoxContainer = $CanvasLayer/TowersContainer/HBoxContainer/SpawnerContainer
@onready var spawner_cost_label: Label = $CanvasLayer/TowersContainer/HBoxContainer/SpawnerContainer/HBoxContainer/SpawnerCostLabel
@onready var key_label3: Label = $CanvasLayer/TowersContainer/HBoxContainer/SpawnerContainer/KeyLabel3
@onready var spawner_image: TextureRect = $CanvasLayer/TowersContainer/HBoxContainer/SpawnerContainer/PanelContainer/SpawnerImage

@onready var blank_container: VBoxContainer = $CanvasLayer/TowersContainer/HBoxContainer/BlankContainer
@onready var blank_cost_label: Label = $CanvasLayer/TowersContainer/HBoxContainer/BlankContainer/HBoxContainer/BlankCostLabel
@onready var key_label4: Label = $CanvasLayer/TowersContainer/HBoxContainer/BlankContainer/KeyLabel4
@onready var blank_image: TextureRect = $CanvasLayer/TowersContainer/HBoxContainer/BlankContainer/PanelContainer/BlankImage

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
	
	sentry_cost_label.text = str(Towers.SENTRY_COST)
	key_label2.text = Utils.get_action_key_name("place_tower2")

	spawner_cost_label.text = str(Towers.SPAWNER_COST)
	key_label3.text = Utils.get_action_key_name("place_tower3")

	blank_cost_label.text = str(Towers.BLANK_COST)
	key_label4.text = Utils.get_action_key_name("place_tower4")
	
	stage_label.text = "Stage " + str(GameState.stage)
	
	if not GameState.is_boss_stage:
		boss_stage_indicator.visible = true
		boss_label.visible = true
		stages_until_boss = GameState.boss_stage_increment - (GameState.stage % GameState.boss_stage_increment)
		boss_label.text = "Stages Until Boss: " + str(stages_until_boss)
		
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

func _process(delta: float) -> void:
	gold_label.text = str(PlayerState.gold)
	health_label.text = str(PlayerState.health) + " / " + str(PlayerState.max_health)
	kills_label.text = str(PlayerState.enemies_killed)
	xp_label.text = str(PlayerState.xp) + " / " + str(PlayerState.level_up_condition)
	xp_bar.max_value = PlayerState.level_up_condition
	xp_bar.value = PlayerState.xp
	
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
