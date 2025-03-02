extends Node

var arena_scene: PackedScene = preload("res://arena/arena.tscn")
var shop_scene: PackedScene = preload("res://shop/Shop.tscn")
var item_card_scene: PackedScene = preload("res://shop/ItemCard.tscn")
var player_projectile_scene: PackedScene = preload("res://projectiles/PlayerProjectile.tscn")
var enemy_projectile_scene: PackedScene = preload("res://projectiles/EnemyProjectile.tscn")

var gold_scene: PackedScene = preload("res://pickups/gold/Gold.tscn")
var xp_scene: PackedScene = preload("res://pickups/xp/Xp.tscn")
var xp2_scene: PackedScene = preload("res://pickups/xp/Xp2.tscn")
var item_pickup_scene: PackedScene = preload("res://pickups/item/ItemPickup.tscn")

var door_scene: PackedScene = preload("res://door/Door.tscn")
var hit_effect_scene: PackedScene = preload("res://effects/HitEffect.tscn")
var sword_scene: PackedScene = preload("res://items/sword/Sword.tscn")
var item_cell_scene: PackedScene = preload("res://overlay/ItemCell.tscn")

var cross_tower_scene: PackedScene = preload("res://towers/sprayer/CrossTower.tscn")
var cardinal_tower_scene: PackedScene = preload("res://towers/sprayer/extra_spray/CardinalTower.tscn")
var double_cross_tower_scene: PackedScene = preload("res://towers/sprayer/barrage/DoubleCrossTower.tscn")
var ring_tower_scene: PackedScene = preload("res://towers/sprayer/ring/RingTower.tscn")

var sentry_tower_scene: PackedScene = preload("res://towers/sentry/SentryTower.tscn")
var sniper_tower_scene: PackedScene = preload("res://towers/sentry/sniper/SniperTower.tscn")
var machine_gun_tower_scene: PackedScene = preload("res://towers/sentry/rapid/MachineGunTower.tscn")
var shotgun_tower_scene: PackedScene = preload("res://towers/sentry/shotgun/ShotgunTower.tscn")

var spawner_tower_scene: PackedScene = preload("res://towers/spawner/SpawnerTower.tscn")
var shooter_spawner_tower_scene: PackedScene = preload("res://towers/spawner/ShooterSpawnerTower.tscn")
var person_spawner_tower_scene: PackedScene = preload("res://towers/spawner/person/PersonSpawner.tscn")
var drifter_spawner_tower_scene: PackedScene = preload("res://towers/spawner/drifter/DrifterSpawner.tscn")

var blank_tower_scene: PackedScene = preload("res://towers/blank/BlankTower.tscn")
var supporter_tower_scene: PackedScene = preload("res://towers/blank/support/SupportTower.tscn")
var pylon_tower_scene: PackedScene = preload("res://towers/blank/pylon/PylonTower.tscn")
var slowing_pylon_tower_scene: PackedScene = preload("res://towers/blank/pylon/slowing/SlowingPylonTower.tscn")
var gold_dispenser_tower_scene: PackedScene = preload("res://towers/blank/economy/GoldDispenserTower.tscn")
var slots_tower_scene: PackedScene = preload("res://towers/blank/economy/gambling/SlotMachine.tscn")
var double_gold_dispenser_tower_scene: PackedScene = preload("res://towers/blank/economy/DoubleGoldTower.tscn")

## Boss scenes
var deflector_boss_scene: PackedScene = preload("res://enemies/bosses/DeflectorBoss.tscn")

## Stage one enemies
var basic_shooter_scene: PackedScene = preload("res://enemies/stage1/BasicEnemy.tscn")
var weak_rusher_scene: PackedScene = preload("res://enemies/stage1/WeakRusher.tscn")

## Stage two enemies
var tanky_enemy_scene: PackedScene = preload("res://enemies/stage2/TankyEnemy.tscn")

## Stage three enemies
var shotgun_enemy_scene: PackedScene = preload("res://enemies/stage3/ShotgunEnemy.tscn")
var shielded_rusher_scene: PackedScene = preload("res://enemies/stage3/ShieldedRusher.tscn")

## Stage four enemies
var sniper_enemy_scene: PackedScene = preload("res://enemies/stage2/SniperEnemy.tscn")

## Stage five enemies
var stealthy_enemy_scene: PackedScene = preload("res://enemies/stage4/StealthStraferEnemy.tscn")

var boss_scenes: Array[PackedScene] = [deflector_boss_scene]
var stage_one_enemy_scenes: Array[PackedScene] = [weak_rusher_scene, basic_shooter_scene]
var stage_two_enemy_scenes: Array[PackedScene] = [tanky_enemy_scene]
var stage_three_enemy_scenes: Array[PackedScene] = [shotgun_enemy_scene, shielded_rusher_scene]
var stage_four_enemy_scenes: Array[PackedScene] = [sniper_enemy_scene]
var stage_five_enemy_scenes: Array[PackedScene] = [stealthy_enemy_scene]
