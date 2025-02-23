extends HBoxContainer

@onready var level_up_label: Label = $StatsAllocation/VBoxContainer/LevelUpLabel
@onready var damage_button: TextureButton = $StatsAllocation/VBoxContainer/DamageContainer/PanelContainer/HBoxContainer/DamageButton
@onready var regen_button: TextureButton = $StatsAllocation/VBoxContainer/RegenContainer/PanelContainer/HBoxContainer/RegenButton
@onready var speed_button: TextureButton = $StatsAllocation/VBoxContainer/SpeedContainer/PanelContainer/HBoxContainer/SpeedButton
@onready var knockback_button: TextureButton = $StatsAllocation/VBoxContainer/KnockbackContainer/PanelContainer/HBoxContainer/KnockbackButton
@onready var attack_speed_button: TextureButton = $StatsAllocation/VBoxContainer/AttackSpeedContainer/PanelContainer/HBoxContainer/ATKSpeedButton
@onready var max_health_button: TextureButton = $StatsAllocation/VBoxContainer/MaxHealthContainer/PanelContainer/HBoxContainer/MaxHealthButton
@onready var bullet_size_button: TextureButton = $StatsAllocation/VBoxContainer/BulletSizeContainer/PanelContainer/HBoxContainer/BulletSizeButton
@onready var bullet_speed_button: TextureButton = $StatsAllocation/VBoxContainer/BulletSpeedContainer/PanelContainer/HBoxContainer/BulletSpeedButton
@onready var pierce_button: TextureButton = $StatsAllocation/VBoxContainer/PierceContainer/PanelContainer/HBoxContainer/PierceButton

@onready var damage_container: PanelContainer = $StatsAllocation/VBoxContainer/DamageContainer/PanelContainer
@onready var regen_container: PanelContainer = $StatsAllocation/VBoxContainer/RegenContainer/PanelContainer
@onready var speed_container: PanelContainer = $StatsAllocation/VBoxContainer/SpeedContainer/PanelContainer
@onready var knockback_container: PanelContainer = $StatsAllocation/VBoxContainer/KnockbackContainer/PanelContainer
@onready var attack_speed_container: PanelContainer = $StatsAllocation/VBoxContainer/AttackSpeedContainer/PanelContainer
@onready var max_health_container: PanelContainer = $StatsAllocation/VBoxContainer/MaxHealthContainer/PanelContainer
@onready var bullet_size_container: PanelContainer = $StatsAllocation/VBoxContainer/BulletSizeContainer/PanelContainer
@onready var bullet_speed_container: PanelContainer = $StatsAllocation/VBoxContainer/BulletSpeedContainer/PanelContainer
@onready var pierce_container: PanelContainer = $StatsAllocation/VBoxContainer/PierceContainer/PanelContainer

@onready var level_label: Label = $StatsDisplay/PanelContainer/VBoxContainer/LevelLabel
@onready var damage_quantity: Label = $StatsDisplay/PanelContainer/VBoxContainer/Damage/DamageQuantity
@onready var regen_quantity: Label = $StatsDisplay/PanelContainer/VBoxContainer/Regen/RegenQuantity
@onready var speed_quantity: Label = $StatsDisplay/PanelContainer/VBoxContainer/Speed/SpeedQuantity
@onready var knockback_quantity: Label = $StatsDisplay/PanelContainer/VBoxContainer/Knockback/KnockbackQuantity
@onready var atk_speed_quantity: Label = $StatsDisplay/PanelContainer/VBoxContainer/ATKSpeed/ATKSpeedQuantity
@onready var max_hp_quantity: Label = $StatsDisplay/PanelContainer/VBoxContainer/MaxHP/MaxHPQuantity
@onready var bullet_size_quantity: Label = $StatsDisplay/PanelContainer/VBoxContainer/BulletSize/BulletSizeQuantity
@onready var pierce_quantity: Label = $StatsDisplay/PanelContainer/VBoxContainer/Pierce/PierceQuantity

func _ready() -> void:
	EventBus.level_up.connect(_on_level_up)
	damage_button.pressed.connect(damage_up)
	regen_button.pressed.connect(regen_up)
	speed_button.pressed.connect(speed_up)
	knockback_button.pressed.connect(knockback_up)
	attack_speed_button.pressed.connect(attack_speed_up)
	max_health_button.pressed.connect(max_health_up)
	bullet_size_button.pressed.connect(bullet_size_up)
	bullet_speed_button.pressed.connect(bullet_speed_up)
	pierce_button.pressed.connect(pierce_up)
	damage_container.mouse_entered.connect(_damage_container_entered)
	damage_container.mouse_exited.connect(_damage_container_exited)
	regen_container.mouse_entered.connect(_regen_container_entered)
	regen_container.mouse_exited.connect(_regen_container_exited)
	speed_container.mouse_entered.connect(_speed_container_entered)
	speed_container.mouse_exited.connect(_speed_container_exited)
	knockback_container.mouse_entered.connect(_knockback_container_entered)
	knockback_container.mouse_exited.connect(_knockback_container_exited)
	attack_speed_container.mouse_entered.connect(_attack_speed_container_entered)
	attack_speed_container.mouse_exited.connect(_attack_speed_container_exited)
	max_health_container.mouse_entered.connect(_max_health_container_entered)
	max_health_container.mouse_exited.connect(_max_health_container_exited)
	bullet_size_container.mouse_entered.connect(_bullet_size_container_entered)
	bullet_size_container.mouse_exited.connect(_bullet_size_container_exited)
	bullet_speed_container.mouse_entered.connect(_bullet_speed_container_entered)
	bullet_speed_container.mouse_exited.connect(_bullet_speed_container_exited)
	pierce_container.mouse_entered.connect(_pierce_container_entered)
	pierce_container.mouse_exited.connect(_pierce_container_exited)
	self.visible = false
	if PlayerState.levels_available > 0:
		_on_level_up()

func _damage_container_entered() -> void:
	damage_container.modulate = Color8(255, 255, 255, 150)
func _damage_container_exited() -> void:
	damage_container.modulate = Color8(255, 255, 255, 255)

func _regen_container_entered() -> void:
	regen_container.modulate = Color8(255, 255, 255, 150)
func _regen_container_exited() -> void:
	regen_container.modulate = Color8(255, 255, 255, 255)

func _speed_container_entered() -> void:
	speed_container.modulate = Color8(255, 255, 255, 150)
func _speed_container_exited() -> void:
	speed_container.modulate = Color8(255, 255, 255, 255)

func _knockback_container_entered() -> void:
	knockback_container.modulate = Color8(255, 255, 255, 150)
func _knockback_container_exited() -> void:
	knockback_container.modulate = Color8(255, 255, 255, 255)

func _attack_speed_container_entered() -> void:
	attack_speed_container.modulate = Color8(255, 255, 255, 150)
func _attack_speed_container_exited() -> void:
	attack_speed_container.modulate = Color8(255, 255, 255, 255)

func _max_health_container_entered() -> void:
	max_health_container.modulate = Color8(255, 255, 255, 150)
func _max_health_container_exited() -> void:
	max_health_container.modulate = Color8(255, 255, 255, 255)

func _bullet_size_container_entered() -> void:
	bullet_size_container.modulate = Color8(255, 255, 255, 150)
func _bullet_size_container_exited() -> void:
	bullet_size_container.modulate = Color8(255, 255, 255, 255)

func _bullet_speed_container_entered() -> void:
	bullet_speed_container.modulate = Color8(255, 255, 255, 150)
func _bullet_speed_container_exited() -> void:
	bullet_speed_container.modulate = Color8(255, 255, 255, 255)

func _pierce_container_entered() -> void:
	pierce_container.modulate = Color8(255, 255, 255, 150)
func _pierce_container_exited() -> void:
	pierce_container.modulate = Color8(255, 255, 255, 255)

func _on_level_up() -> void:
	level_up_label.text = "Level Up"
	level_label.text = "Level " + str(PlayerState.level)
	damage_quantity.text = str(PlayerState.damage)
	damage_quantity.text = str(PlayerState.damage)
	regen_quantity.text = str(PlayerState.regen)
	speed_quantity.text = str(PlayerState.speed)
	knockback_quantity.text = str(PlayerState.knockback)
	atk_speed_quantity.text = str(PlayerState.firerate)
	max_hp_quantity.text = str(PlayerState.max_health)
	bullet_size_quantity.text = str(PlayerState.bullet_size)
	pierce_quantity.text = str(PlayerState.pierce)
	self.visible = true
	EventBus.pause_game.emit()

func damage_up() -> void:
	PlayerState.damage += 5
	level_down()

func regen_up() -> void:
	PlayerState.regen += 1
	level_down()

func speed_up() -> void:
	PlayerState.speed += 25
	level_down()

func knockback_up() -> void:
	PlayerState.knockback += 1
	level_down()

func attack_speed_up() -> void:
	PlayerState.firerate -= 0.05
	level_down()

func max_health_up() -> void:
	PlayerState.max_health += 10
	PlayerState.health = min(PlayerState.health + 10, PlayerState.max_health)
	level_down()

func bullet_size_up() -> void:
	PlayerState.bullet_size += 0.25
	level_down()

func bullet_speed_up() -> void:
	PlayerState.projectile_speed += 50
	level_down()

func pierce_up() -> void:
	PlayerState.pierce += 1
	level_down()

func level_down() -> void:
	PlayerState.levels_available -= 1
	_on_level_up()
	if PlayerState.levels_available < 1:
		self.visible = false
		EventBus.unpause_game.emit()
