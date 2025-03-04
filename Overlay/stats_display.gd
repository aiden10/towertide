extends MarginContainer

@onready var level_label: Label = $HBoxContainer/PanelContainer/VBoxContainer/LevelLabel
@onready var damage_quantity: Label = $HBoxContainer/PanelContainer/VBoxContainer/Damage/DamageQuantity
@onready var regen_quantity: Label = $HBoxContainer/PanelContainer/VBoxContainer/Regen/RegenQuantity
@onready var speed_quantity: Label = $HBoxContainer/PanelContainer/VBoxContainer/Speed/SpeedQuantity
@onready var knockback_quantity: Label = $HBoxContainer/PanelContainer/VBoxContainer/Knockback/KnockbackQuantity
@onready var atk_speed_quantity: Label = $HBoxContainer/PanelContainer/VBoxContainer/ATKSpeed/ATKSpeedQuantity
@onready var max_hp_quantity: Label = $HBoxContainer/PanelContainer/VBoxContainer/MaxHP/MaxHPQuantity
@onready var bullet_size_quantity: Label = $HBoxContainer/PanelContainer/VBoxContainer/BulletSize/BulletSizeQuantity
@onready var bullet_speed_quantity: Label = $HBoxContainer/PanelContainer/VBoxContainer/BulletSpeed/BulletSpeedQuantity
@onready var pierce_quantity: Label = $HBoxContainer/PanelContainer/VBoxContainer/Pierce/PierceQuantity

func show_stats() -> void:
	self.visible = true
	level_label.text = "Level " + str(PlayerState.level)
	damage_quantity.text = str(PlayerState.damage)
	damage_quantity.text = str(PlayerState.damage)
	regen_quantity.text = str(PlayerState.regen)
	speed_quantity.text = str(PlayerState.speed)
	knockback_quantity.text = str(PlayerState.knockback)
	atk_speed_quantity.text = str(PlayerState.firerate)
	max_hp_quantity.text = str(PlayerState.max_health)
	bullet_speed_quantity.text = str(PlayerState.projectile_speed)
	bullet_size_quantity.text = str(PlayerState.bullet_size)
	pierce_quantity.text = str(PlayerState.pierce)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_stats"):
		show_stats()
	elif event.is_action_released("show_stats"):
		self.visible = false
