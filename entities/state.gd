extends Node

class_name State

signal transitioned
var minion: Minion
var enemy: Enemy

func enter() -> void:
	pass

func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func setup_minion(minion_node: Minion) -> void:
	minion = minion_node
	
func get_detection_range() -> Area2D:
	return minion.get_node("DetectionRange")

func get_attack_range() -> Area2D:
	return minion.get_node("AttackRange")

func setup_enemy(enemy_node: Enemy) -> void:
	enemy = enemy_node
