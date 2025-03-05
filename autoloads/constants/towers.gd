extends Node

const CROSS_COST: int = 5
const CROSS_NAME: String = "Sprayer"
const CROSS_DESCRIPTION: String = "Shoots bullets alternating between a cross and x pattern"
const CROSS_COOLDOWN: float = 2.5
const CROSS_SPEED_PERCENTAGE: float = 0.75 
const CROSS_DAMAGE_PERCENTAGE: float = 0.5
const CROSS_BULLET_SCALE: float = 0.6
var CROSS_IMAGE: Texture = load("res://sprites/towers/cross/f1.png")
const CROSS_SCENE_PATH: String = "res://towers/sprayer/CrossTower.tscn"

const CARDINAL_COST: int = 10
const CARDINAL_NAME: String = "Cardinal"
const CARDINAL_DESCRIPTION: String = "Shoots bullets in all cardinal directions"
const CARDINAL_COOLDOWN: float = 2
const CARDINAL_SPEED_PERCENTAGE: float = 0.75 
const CARDINAL_DAMAGE_PERCENTAGE: float = 0.75 
const CARDINAL_BULLET_SCALE: float = 0.75
var CARDINAL_IMAGE: Texture = load("res://sprites/towers/cardinal/cardinal.png")
const CARDINAL_SCENE_PATH: String = "res://towers/sprayer/extra_spray/CardinalTower.tscn"

const SUPER_SPRAYER_COST: int = 15
const SUPER_SPRAYER_NAME: String = "Super Sprayer"
const SUPER_SPRAYER_DESCRIPTION: String = "Shoots 4 additional bullets"
const SUPER_SPRAYER_COOLDOWN: float = 1.5
const SUPER_SPRAYER_SPEED_PERCENTAGE: float = 0.75 
const SUPER_SPRAYER_DAMAGE_PERCENTAGE: float = 0.75 
const SUPER_SPRAYER_BULLET_SCALE: float = 0.75
var SUPER_SPRAYER_IMAGE: Texture = load("res://sprites/towers/cardinal/super_sprayer.png")
const SUPER_SPRAYER_SCENE_PATH: String = "res://towers/sprayer/extra_spray/super_sprayer/SuperSprayer.tscn"

const ATOMIZER_COST: int = 30
const ATOMIZER_NAME: String = "Atomizer"
const ATOMIZER_DESCRIPTION: String = "Rapidly fires bullets everywhere"
const ATOMIZER_COOLDOWN: float = 0.5
const ATOMIZER_SPEED_PERCENTAGE: float = 0.75 
const ATOMIZER_DAMAGE_PERCENTAGE: float = 0.25
const ATOMIZER_BULLET_SCALE: float = 0.35
var ATOMIZER_IMAGE: Texture = load("res://sprites/towers/cardinal/atomizer.png")
const ATOMIZER_SCENE_PATH: String = "res://towers/sprayer/extra_spray/super_sprayer/atomizer/AtomizerTower.tscn"

const CLOUD_COST: int = 15
const CLOUD_NAME: String = "Bullet Cloud"
const CLOUD_DESCRIPTION: String = "Rains bullets on enemies"
const CLOUD_COOLDOWN: float = 0.15
const CLOUD_SPEED_PERCENTAGE: float = 0.25 
const CLOUD_DAMAGE_PERCENTAGE: float = 0.2 
const CLOUD_BULLET_SCALE: float = 0.45
var CLOUD_IMAGE: Texture = load("res://sprites/towers/cardinal/cloud.png")
const CLOUD_SCENE_PATH: String = "res://towers/sprayer/extra_spray/cloud/CloudTower.tscn"

const RING_NAME: String = "Ring Shooter"
const RING_COST: int = 10
const RING_DESCRIPTION: String = "Emits a ring which deals damage to enemies inside it"
const RING_COOLDOWN: float = 0.5
const RING_SPEED_PERCENTAGE: float = 1
const RING_DAMAGE_PERCENTAGE: float = 0.25
var RING_IMAGE: Texture = load("res://sprites/towers/cross/ring/ring_tower.png")
const RING_SCENE_PATH: String = "res://towers/sprayer/ring/RingTower.tscn"

const DOUBLE_CROSS_NAME: String = "Double Cross"
const DOUBLE_CROSS_COST: int = 10
const DOUBLE_CROSS_DESCRIPTION: String = "Shoots 2 bullets in a cross pattern"
const DOUBLE_CROSS_COOLDOWN: float = 2
const DOUBLE_CROSS_BULLET_SCALE: float = 0.75
const DOUBLE_CROSS_SPEED_PERCENTAGE: float = 0.75
const DOUBLE_CROSS_DAMAGE_PERCENTAGE: float = 0.75
var DOUBLE_CROSS_IMAGE: Texture = load("res://sprites/towers/cross/barrage/double_cross.png")
const DOUBLE_CROSS_SCENE_PATH: String = "res://towers/sprayer/barrage/DoubleCrossTower.tscn"

const SENTRY_COST: int = 10
const SENTRY_NAME: String = "Sentry"
const SENTRY_DESCRIPTION: String = "Automatically tracks and shoots enemies"
const SENTRY_COOLDOWN: float = 1.25
const SENTRY_SPEED_PERCENTAGE: float = 1 
const SENTRY_BULLET_SCALE: float = 0.7
const SENTRY_DAMAGE_PERCENTAGE: float = 0.4
var SENTRY_IMAGE: Texture = load("res://sprites/towers/sentry/sentry.png")
const SENTRY_SCENE_PATH: String = "res://towers/sentry/SentryTower.tscn"

const SNIPER_COST: int = 15
const SNIPER_NAME: String = "Sniper"
const SNIPER_DESCRIPTION: String = "Shoots fast, high damage projectiles"
const SNIPER_COOLDOWN: float = 3
const SNIPER_SPEED_PERCENTAGE: float = 2.5
const SNIPER_DAMAGE_PERCENTAGE: float = 2
const SNIPER_BULLET_SCALE: float = 0.55
var SNIPER_IMAGE: Texture = load("res://sprites/towers/sentry/sniper/sniper.png")
const SNIPER_SCENE_PATH: String = "res://towers/sentry/sniper/SniperTower.tscn"

const CANNON_COST: int = 25
const CANNON_NAME: String = "Cannon"
const CANNON_DESCRIPTION: String = "Aimable tower which shoots massive bullets that deal massive damage"
const CANNON_COOLDOWN: float = 5
const CANNON_SPEED_PERCENTAGE: float = 350
const CANNON_DAMAGE_PERCENTAGE: float = 4.5
const CANNON_BULLET_SCALE: float = 1.15
const CANNON_EXTRA_PIERCE: float = 5
var CANNON_IMAGE: Texture = load("res://sprites/towers/sentry/sniper/cannon/cannon.png")
const CANNON_SCENE_PATH: String = "res://towers/sentry/sniper/cannon/CannonTower.tscn"

const MACHINE_GUN_COST: int = 15
const MACHINE_GUN_NAME: String = "Machine Gun"
const MACHINE_GUN_DESCRIPTION: String = "Rapidly shoots detected enemies"
const MACHINE_GUN_COOLDOWN: float = 0.4
const MACHINE_GUN_SPEED_PERCENTAGE: float = 1.5
const MACHINE_GUN_DAMAGE_PERCENTAGE: float = 0.2
var MACHINE_GUN_IMAGE: Texture = load("res://sprites/towers/sentry/machine_gun/f1.png")
const MACHINE_GUN_SCENE_PATH: String = "res://towers/sentry/rapid/MachineGunTower.tscn"

const SHOTGUN_COST: int = 15
const SHOTGUN_NAME: String = "Shotgun"
const SHOTGUN_DESCRIPTION: String = "Shoots 3 slower, but stronger bullets"
const SHOTGUN_COOLDOWN: float = 2
const SHOTGUN_SPEED_PERCENTAGE: float = 0.75
const SHOTGUN_DAMAGE_PERCENTAGE: float = 1.0
const SHOTGUN_BULLET_SCALE: float = 0.55
const SHOTGUN_SHOT_COUNT: int = 3
var SHOTGUN_IMAGE: Texture = load("res://sprites/towers/sentry/shotgun/shotgun_tower.png")
const SHOTGUN_SCENE_PATH: String = "res://towers/sentry/shotgun/ShotgunTower.tscn"

const GRAPESHOT_COST: int = 25
const GRAPESHOT_NAME: String = "Grapeshot"
const GRAPESHOT_DESCRIPTION: String = "Shoots a large cluster of bullets"
const GRAPESHOT_COOLDOWN: float = 2.75
const GRAPESHOT_SPEED_PERCENTAGE: float = 0.75
const GRAPESHOT_DAMAGE_PERCENTAGE: float = 0.65
const GRAPESHOT_BULLET_SCALE: float = 0.45
const GRAPESHOT_SHOT_COUNT: int = 8
var GRAPESHOT_IMAGE: Texture = load("res://sprites/towers/sentry/shotgun/grapeshot/grapeshot.png")
const GRAPESHOT_SCENE_PATH: String = "res://towers/sentry/shotgun/grapeshot/GrapeshotTower.tscn"

const SPAWNER_COST: int = 15
const SPAWNER_SPAWN_AMOUNT: int = 2
const SPAWNER_NAME: String = "Spawner"
const SPAWNER_DESCRIPTION: String = "Automatically spawns minions"
const SPAWNER_COOLDOWN: float = 2.5
const SPAWNER_SPAWN_LIMIT: int = 3
var SPAWNER_IMAGE: Texture = load("res://sprites/towers/spawner/spawner.png")

const SPAWNER_SCENE_PATH: String = "res://towers/spawner/SpawnerTower.tscn"

const SHOOTER_SPAWNER_COST: int = 15
const SHOOTER_SPAWNER_SPAWN_AMOUNT: int = 1
const SHOOTER_SPAWNER_NAME: String = "Shooter Spawner"
const SHOOTER_SPAWNER_DESCRIPTION: String = "Spawns minions that shoot enemies"
const SHOOTER_SPAWNER_COOLDOWN: float = 1

const SHOOTER_SPAWNER_SPAWN_LIMIT: int = 5
var SHOOTER_SPAWNER_IMAGE: Texture = load("res://sprites/towers/spawner/shooter/shooter_spawner.png")
const SHOOTER_SPAWNER_SCENE_PATH: String = "res://towers/spawner/ShooterSpawnerTower.tscn"

const PERSON_SPAWNER_COST: int = 10
const PERSON_SPAWNER_SPAWN_AMOUNT: int = 1
const PERSON_SPAWNER_NAME: String = "Person Spawner"
const PERSON_SPAWNER_DESCRIPTION: String = "Spawns weak people with high potential"
const PERSON_SPAWNER_COOLDOWN: float = 2.5

const PERSON_SPAWNER_SPAWN_LIMIT: int = 8
var PERSON_SPAWNER_IMAGE: Texture = load("res://sprites/towers/spawner/person_spawner.png")
const PERSON_SPAWNER_SCENE_PATH: String = "res://towers/spawner/person/PersonSpawner.tscn"

const BUG_SPAWNER_COST: int = 15
const BUG_SPAWNER_SPAWN_AMOUNT: int = 5
const BUG_SPAWNER_NAME: String = "Insect Spawner"
const BUG_SPAWNER_DESCRIPTION: String = "Spawns many weak bugs"
const BUG_SPAWNER_COOLDOWN: float = 1

const BUG_SPAWNER_SPAWN_LIMIT: int = 20
var BUG_SPAWNER_IMAGE: Texture = load("res://sprites/towers/spawner/bug_spawner.png")
const BUG_SPAWNER_SCENE_PATH: String = "res://towers/spawner/swarm/SwarmSpawner.tscn"

const DRIFTER_SPAWNER_COST: int = 20
const DRIFTER_SPAWNER_SPAWN_AMOUNT: int = 1
const DRIFTER_SPAWNER_NAME: String = "Drifter Spawner"
const DRIFTER_SPAWNER_DESCRIPTION: String = "Spawns wandering minions which stab and shoot"
const DRIFTER_SPAWNER_COOLDOWN: float = 3.5

const DRIFTER_SPAWNER_SPAWN_LIMIT: int = 6
var DRIFTER_SPAWNER_IMAGE: Texture = load("res://sprites/towers/spawner/drifter_spawner.png")
const DRIFTER_SPAWNER_SCENE_PATH: String = "res://towers/spawner/drifter/DrifterSpawner"

const KIDNAPPER_SPAWNER_COST: int = 25
const KIDNAPPER_SPAWNER_SPAWN_AMOUNT: int = 1
const KIDNAPPER_SPAWNER_NAME: String = "Kidnapper Spawner"
const KIDNAPPER_SPAWNER_DESCRIPTION: String = "Spawns minions that kidnap enemies and return them to this tower"
const KIDNAPPER_SPAWNER_COOLDOWN: float = 3.5

const KIDNAPPER_SPAWNER_SPAWN_LIMIT: int = 3
var KIDNAPPER_SPAWNER_IMAGE: Texture = load("res://sprites/towers/spawner/kidnapper_spawner.png")
const KIDNAPPER_SPAWNER_SCENE_PATH: String = "res://towers/spawner/drifter/kidnapper/KidnapperSpawner.tscn"

const BLANK_COST: int = 5
const BLANK_NAME: String = "Blank"
const BLANK_DESCRIPTION: String = "Does nothing until upgraded"
var BLANK_IMAGE: Texture = load("res://sprites/towers/blank/blank.png")
const BLANK_SCENE_PATH: String = "res://towers/blank/BlankTower.tscn"

const SUPPORTER_COST: int = 10
const SUPPORTER_NAME: String = "Supporter"
const SUPPORTER_DESCRIPTION: String = "Towers in range attack faster"
const SUPPORTER_COOLDOWN_REDUCTION: float = 0.8
var SUPPORTER_IMAGE: Texture = load("res://sprites/towers/blank/support/support.png")
const SUPPORTER_SCENE_PATH: String = "res://towers/blank/support/SupportTower.tscn"

const GOLD_DISPENSER_NAME: String = "Gold Dispenser"
const GOLD_DISPENSER_COST: int = 10
const GOLD_DISPENSER_COOLDOWN: float = 8
const GOLD_DISPENSER_DESCRIPTION: String = "Dispenses gold"
var GOLD_DISPENSER_IMAGE: Texture = load("res://sprites/towers/blank/economy/gold_dispenser.png")
const GOLD_DISPENSER_SCENE_PATH: String = "res://towers/blank/economy/GoldDispenserTower.tscn"

const SLOTS_NAME: String = "Slot Machine"
const SLOTS_COST: int = 15
const SLOTS_PLAY_COST: int = 1
const SLOTS_COOLDOWN: float = 8
const SLOTS_DESCRIPTION: String = "Play for a chance to win XP, gold, or an item!"
var SLOTS_IMAGE: Texture = load("res://sprites/towers/blank/economy/slot_machine.png")
const SLOTS_SCENE_PATH: String = "res://towers/blank/economy/gambling/SlotMachine.tscn"
const SLOTS_OPTIONS: Array[String] = ["nothing", "1G", "1XP", "5G", "25XP", "jackpot"]
const SLOTS_WEIGHTS: Array[float] = [2, 0.5, 1, 0.2, 0.2, 0.01]

const DOUBLE_GOLD_DISPENSER_NAME: String = "Double Gold Dispenser"
const DOUBLE_GOLD_DISPENSER_COST: int = 15
const DOUBLE_GOLD_DISPENSER_COOLDOWN: float = 12
const DOUBLE_GOLD_DISPENSER_DESCRIPTION: String = "Dispenses 2 gold"
var DOUBLE_GOLD_DISPENSER_IMAGE: Texture = load("res://sprites/towers/blank/economy/gold_dispenser.png")
const DOUBLE_GOLD_DISPENSER_SCENE_PATH: String = "res://towers/blank/economy/DoubleGoldTower.tscn"

const PYLON_NAME: String = "Pylon"
const PYLON_DESCRIPTION: String = "Creates an electric fence between pylons"
const PYLON_SCENE_PATH: String = "res://towers/blank/pylon/PylonTower.tscn"
const PYLON_COST: int = 5
const PYLON_COOLDOWN: float = 0.25
const PYLON_DAMAGE: float = 0.33
var PYLON_IMAGE: Texture = load("res://sprites/towers/blank/pylon/pylon.png")

const SLOWING_PYLON_NAME: String = "Slowing Pylon"
const SLOWING_PYLON_DESCRIPTION: String = "Slows enemy bullets that enter this tower's area"
const SLOWING_PYLON_SCENE_PATH: String = "res://towers/blank/pylon/slowing/SlowingPylonTower.tscn"
const SLOWING_PYLON_COST: int = 10
const SLOWING_PYLON_COOLDOWN: float = 0.25
const SLOWING_PYLON_DAMAGE: float = 0.4
var SLOWING_PYLON_IMAGE: Texture = load("res://sprites/towers/blank/pylon/pylon.png")

const CHAIN_PYLON_NAME: String = "Chain Pylon"
const CHAIN_PYLON_DESCRIPTION: String = "Creates electric lines between enemies in this tower's range"
const CHAIN_PYLON_SCENE_PATH: String = "res://towers/blank/pylon/chain/ChainPylon.tscn"
const CHAIN_PYLON_COST: int = 10
const CHAIN_PYLON_COOLDOWN: float = 0.25
const CHAIN_PYLON_DAMAGE: float = 0.4
var CHAIN_PYLON_IMAGE: Texture = load("res://sprites/towers/blank/pylon/pylon.png")

var charger_minion_scene: PackedScene = load("res://towers/spawner/minions/charger/ChargerMinion.tscn")
const CHARGER_NAME: String = "Charger"
const CHARGER_SPEED: float = 100
const CHARGER_DAMAGE: float = 0.8
const CHARGER_WANDER_DIST: float = 300
const CHARGER_MIN_WANDER: float = 50
const CHARGER_LIFETIME: float = 5

var bug_minion_scene: PackedScene = load("res://towers/spawner/minions/bug/BugMinion.tscn")
const BUG_NAME: String = "Bug"
const BUG_SPEED: float = 300
const BUG_DAMAGE: float = 0.2
const BUG_WANDER_DIST: float = 175
const BUG_MIN_WANDER: float = 30
const BUG_LIFETIME: float = 6.5

var person_minion_scene: PackedScene = load("res://towers/spawner/minions/person/PersonMinion.tscn")
const PERSON_NAME: String = "Person"
const PERSON_SPEED: float = 200
const PERSON_DAMAGE: float = 0.2
const PERSON_COOLDOWN: float = 3
const PERSON_WANDER_DIST: float = 500
const PERSON_MIN_WANDER: float = 150
const PERSON_LIFETIME: float = 7

var drifter_minion_scene: PackedScene = load("res://towers/spawner/minions/drifter/DrifterMinion.tscn")
const DRIFTER_NAME: String = "Drifter"
const DRIFTER_SPEED: float = 150
const DRIFTER_DAMAGE: float = 0.75
const DRIFTER_COOLDOWN: float = 0.65
const DRIFTER_PROJECTILE_SPEED: float = 1
const DRIFTER_WANDER_DIST: float = 1200
const DRIFTER_MIN_WANDER: float = 500

var kidnapper_minion_scene: PackedScene = load("res://towers/spawner/minions/kidnapper/KidnapperMinion.tscn")
const KIDNAPPER_NAME: String = "Kidnapper"
const KIDNAPPER_SPEED: float = 150
const KIDNAPPER_DAMAGE: float = 0.1
const KIDNAPPER_COOLDOWN: float = 2
const KIDNAPPER_WANDER_DIST: float = 400
const KIDNAPPER_MIN_WANDER: float = 100

var shooter_minion_scene: PackedScene = load("res://towers/spawner/minions/shooter/ShooterMinion.tscn")
const SHOOTER_NAME: String = "Shooter"
const SHOOTER_SPEED: float = 100
const SHOOTER_DAMAGE: float = 0.5
const SHOOTER_COOLDOWN: float = 1.5
const SHOOTER_PROJECTILE_SPEED: float = 0.5
const SHOOTER_WANDER_DIST: float = 300
const SHOOTER_MIN_WANDER: float = 100
const SHOOTER_BULLET_SCALE: float = 0.5

const end_of_path_name: String = "End of path"
const end_of_path_description: String = "No more upgrades available"
var end_of_path_image: Texture = load("res://sprites/towers/lock.png")
const end_of_path_cost: String = "N/A"
