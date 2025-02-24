extends Node2D

@onready var sword_area: Area2D = $SwordArea
var damage: int = Items.SWORD_DAMAGE

func _ready() -> void:
	sword_area.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	damage = Items.SWORD_DAMAGE + PlayerState.damage / 2
	var parent = area.get_parent()

	if parent.is_in_group("Enemies"):
		Utils.spawn_hit_effect(Color(255, 255, 255, 50), parent.global_position, damage)
		parent.take_damage(damage, self)
		
