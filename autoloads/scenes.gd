extends Node

var arena_scene: PackedScene = preload("res://arena/arena.tscn")
var shop_scene: PackedScene = preload("res://shop/Shop.tscn")
var item_card_scene: PackedScene = preload("res://shop/ItemCard.tscn")
var player_projectile_scene: PackedScene = preload("res://projectiles/PlayerProjectile.tscn")
var enemy_projectile_scene: PackedScene = preload("res://projectiles/EnemyProjectile.tscn")

var gold_scene: PackedScene = preload("res://pickups/gold/Gold.tscn")
var xp_scene: PackedScene = preload("res://pickups/xp/Xp.tscn")
var item_pickup_scene: PackedScene = preload("res://pickups/item/ItemPickup.tscn")

var door_scene: PackedScene = preload("res://door/Door.tscn")
var hit_effect_scene: PackedScene = preload("res://effects/HitEffect.tscn")
var sword_scene: PackedScene = preload("res://items/sword/Sword.tscn")
var item_cell_scene: PackedScene = preload("res://overlay/ItemCell.tscn")
var cross_tower_scene: PackedScene = preload("res://towers/sprayer/CrossTower.tscn")
var cardinal_tower_scene: PackedScene = preload("res://towers/sprayer/extra_spray/CardinalTower.tscn")
var sentry_tower_scene: PackedScene = preload("res://towers/sentry/SentryTower.tscn")
var machine_gun_tower_scene: PackedScene = preload("res://towers/sentry/rapid/MachineGunTower.tscn")
var spawner_tower_scene: PackedScene = preload("res://towers/spawner/SpawnerTower.tscn")
var shooter_spawner_tower_scene: PackedScene = preload("res://towers/spawner/ShooterSpawnerTower.tscn")
var blank_tower_scene: PackedScene = preload("res://towers/blank/BlankTower.tscn")
var pylon_tower_scene: PackedScene = preload("res://towers/blank/pylon/PylonTower.tscn")
var slowing_pylon_tower_scene: PackedScene = preload("res://towers/blank/pylon/slowing/SlowingPylonTower.tscn")
var gold_dispenser_tower_scene: PackedScene = preload("res://towers/blank/economy/GoldDispenserTower.tscn")

## Stage one enemies
var basic_shooter_scene: PackedScene = preload("res://enemies/stage1/BasicEnemy.tscn")
var weak_rusher_scene: PackedScene = preload("res://enemies/stage1/WeakRusher.tscn")

## Stage two enemies
var tanky_enemy_scene: PackedScene = preload("res://enemies/stage2/TankyEnemy.tscn")
var sniper_enemy_scene: PackedScene = preload("res://enemies/stage2/SniperEnemy.tscn")

## Stage three enemies
var shotgun_enemy_scene: PackedScene = preload("res://enemies/stage3/ShotgunEnemy.tscn")

var stage_one_enemy_scenes: Array[PackedScene] = [basic_shooter_scene, weak_rusher_scene]
var stage_two_enemy_scenes: Array[PackedScene] = [tanky_enemy_scene, sniper_enemy_scene]
var stage_three_enemy_scenes: Array[PackedScene] = [shotgun_enemy_scene]
