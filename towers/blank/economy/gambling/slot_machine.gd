extends Tower

var can_play: bool = false
@onready var bet_container: PanelContainer = $BetContainer
@onready var bet_label: RichTextLabel = $BetContainer/BetLabel
@onready var core_sprite: Sprite2D = $CoreSprite

func _init() -> void:
	super()
	base_type = 4
	tower_name = Towers.SLOTS_NAME
	description = Towers.SLOTS_DESCRIPTION
	cost = Towers.SLOTS_COST
	value = cost
	cooldown = Towers.SLOTS_COOLDOWN
	image = Towers.SLOTS_IMAGE
	scene_path = Towers.SLOTS_SCENE_PATH
	shot_timer = cooldown

func _ready() -> void:
	bet_container.modulate = Color(1, 1, 1, 0)
	bet_label.text = "[center][wave amp=100 freq=4]Press " + Utils.get_action_key_name("enter") + " to play! (" + str(Towers.SLOTS_PLAY_COST) + " gold)[/wave][/center]" 

	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	var pulse_tween = create_tween()
	pulse_tween.set_loops(-1)
	pulse_tween.set_trans(Tween.TRANS_SINE)
	pulse_tween.set_ease(Tween.EASE_IN_OUT)
	pulse_tween.parallel().tween_property(core_sprite, "modulate", Color(1, 2.5, 2, 1), 1)
	pulse_tween.parallel().tween_property(core_sprite, "modulate", Color(1, 1, 1, 0.8), 1)

func play_slots() -> void:
	if PlayerState.minimum_gold + PlayerState.gold < Towers.SLOTS_PLAY_COST:
		EventBus.invalid_action.emit()
		return

	PlayerState.gold -= Towers.SLOTS_PLAY_COST
	
	var result: String = Utils.weighted_random_choice(Towers.SLOTS_WEIGHTS, Towers.SLOTS_OPTIONS)
	Utils.spawn_hit_effect(Color8(510, 510, 100, 255), self.global_position, randi_range(4, 8))
	if result == "nothing":
		EventBus._slots_lost.emit()
	elif result == "1G":
		PickupManager.spawn_gold(self.global_position)
		killed_enemy.emit()
		EventBus._slots_won.emit()
	elif result == "1XP":
		PickupManager.spawn_xp(self.global_position, 1)
	elif result == "5G":
		for i in range(5):
			PickupManager.spawn_gold(Utils.get_random_position_in_radius(self.global_position, 200, 100))
			killed_enemy.emit()
		EventBus._slots_won.emit()
	elif result == "25XP":
		for i in range(5):
			PickupManager.spawn_xp(Utils.get_random_position_in_radius(self.global_position, 200, 100), 2)
		EventBus._slots_won.emit()
	## Jackpot will give xp, gold, and an item
	elif result == "jackpot":
		for i in range(int(PlayerState.level_up_condition / 5)):
			PickupManager.spawn_xp(Utils.get_random_position_in_radius(self.global_position, 200, 100), 2)
		for i in range(25):
			PickupManager.spawn_gold(Utils.get_random_position_in_radius(self.global_position, 200, 100))
			killed_enemy.emit()
		PickupManager.spawn_item(Utils.get_random_position_in_radius(self.global_position, 200, 100))
		EventBus._slots_jackpot.emit()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter") and can_play:
		play_slots()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		can_play = true
		var tween = create_tween()
		tween.tween_property(bet_container, "modulate", Color(1, 1, 1, 1), 0.3)

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		can_play = false
		var tween = create_tween()
		tween.tween_property(bet_container, "modulate", Color(1, 1, 1, 0), 0.3)
