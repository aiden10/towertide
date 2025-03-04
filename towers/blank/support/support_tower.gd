extends Tower

@onready var connect_radius: Area2D = $ConnectRadius

func _init() -> void:
	base_type = 4
	super()
	tower_name = Towers.SUPPORTER_NAME
	description = Towers.SUPPORTER_DESCRIPTION
	cost = Towers.SUPPORTER_COST
	value = cost
	image = Towers.SUPPORTER_IMAGE
	scene_path = Towers.SUPPORTER_SCENE_PATH

func _ready() -> void:
	connect_radius.area_entered.connect(connect_radius_entered)

func connect_radius_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Towers") and not area.is_in_group("DetectionRadius") and parent != self:
		if parent.tower_name == Towers.SUPPORTER_NAME:
			return
		parent.cooldown *= Towers.SUPPORTER_COOLDOWN_REDUCTION
		Utils.spawn_hit_effect(Color8(255, 225, 15, 255), parent.global_position, 8)
		## Attach hand
		var hand_sprite: Sprite2D = Sprite2D.new()
		var hand_line: Line2D = Line2D.new()
		hand_sprite.texture = load("res://sprites/towers/blank/support/hand.png")
		hand_sprite.position = parent.position - position
		hand_sprite.position.y -= 20
		hand_sprite.scale *= 0.75
		hand_sprite.modulate = Color(1, 1, 1, 0.25)
		hand_line.width = 5.0
		hand_line.default_color = Color8(490, 350, 100, 128)
		hand_line.add_point(Vector2.ZERO)
		hand_line.add_point(parent.position - position)
		
		add_child(hand_sprite)
		add_child(hand_line)
