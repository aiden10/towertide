extends Node

var arena_scene: PackedScene = preload("res://arena/arena.tscn")
var shop_scene: PackedScene = preload("res://shop/Shop.tscn")
var item_card_scene: PackedScene = preload("res://shop/ItemCard.tscn")
var player_projectile_scene: PackedScene = preload("res://projectiles/PlayerProjectile.tscn")
var enemy_projectile_scene: PackedScene = preload("res://projectiles/EnemyProjectile.tscn")
var gold_scene: PackedScene = preload("res://pickups/gold/Gold.tscn")
var xp_scene: PackedScene = preload("res://pickups/xp/Xp.tscn")
var door_scene: PackedScene = preload("res://door/Door.tscn")
var hit_effect_scene: PackedScene = preload("res://effects/HitEffect.tscn")
var sword_scene: PackedScene = preload("res://items/sword/Sword.tscn")
var item_cell_scene: PackedScene = preload("res://overlay/ItemCell.tscn")
var cross_tower_scene: PackedScene = preload("res://towers/cross/CrossTower.tscn")
var sentry_tower_scene: PackedScene = preload("res://towers/sentry/SentryTower.tscn")
var spawner_tower_scene: PackedScene = preload("res://towers/spawner/SpawnerTower.tscn")
var blank_tower_scene: PackedScene = preload("res://towers/blank/BlankTower.tscn")
var pylon_tower_scene: PackedScene = preload("res://towers/blank/pylon/PylonTower.tscn")

## Stage one enemies
var basic_shooter_scene: PackedScene = preload("res://enemies/stage1/BasicEnemy.tscn")
var weak_rusher_scene: PackedScene = preload("res://enemies/stage1/WeakRusher.tscn")
var stage_one_enemy_scenes: Array[PackedScene] = [basic_shooter_scene, weak_rusher_scene]

## Stage two enemies
var tanky_enemy_scene: PackedScene = preload("res://enemies/stage2/TankyEnemy.tscn")
var sniper_enemy_scene: PackedScene = preload("res://enemies/stage2/SniperEnemy.tscn")
var stage_two_enemy_scenes: Array[PackedScene] = [tanky_enemy_scene, sniper_enemy_scene]
