extends Node

const CROSS_COST: int = 5
const CROSS_NAME: String = "Cross"
const CROSS_DESCRIPTION: String = "Shoots bullets alternating between a cross and x pattern"
const CROSS_COOLDOWN: float = 2.5
const CROSS_SPEED_PERCENTAGE: float = 0.75 
const CROSS_DAMAGE_PERCENTAGE: float = 0.5 
var CROSS_IMAGE: Texture = load("res://sprites/towers/cross/f1.png")
const CROSS_SCENE_PATH: String = "res://towers/sprayer/CrossTower.tscn"

const CARDINAL_COST: int = 10
const CARDINAL_NAME: String = "Cardinal"
const CARDINAL_DESCRIPTION: String = "Shoots bullets in all cardinal directions"
const CARDINAL_COOLDOWN: float = 2.5
const CARDINAL_SPEED_PERCENTAGE: float = 0.75 
const CARDINAL_DAMAGE_PERCENTAGE: float = 0.5 
var CARDINAL_IMAGE: Texture = load("res://sprites/towers/cardinal/cardinal.png")
const CARDINAL_SCENE_PATH: String = "res://towers/sprayer/extra_spray/CardinalTower.tscn"

const SENTRY_COST: int = 10
const SENTRY_NAME: String = "Sentry"
const SENTRY_DESCRIPTION: String = "Automatically tracks and shoots enemies"
const SENTRY_COOLDOWN: float = 1.25
const SENTRY_SPEED_PERCENTAGE: float = 1 
const SENTRY_DAMAGE_PERCENTAGE: float = 0.4
var SENTRY_IMAGE: Texture = load("res://sprites/towers/sentry/sentry.png")
const SENTRY_SCENE_PATH: String = "res://towers/sentry/SentryTower.tscn"

const MACHINE_GUN_COST: int = 15
const MACHINE_GUN_NAME: String = "Machine Gun"
const MACHINE_GUN_DESCRIPTION: String = "Rapidly shoots detected enemies"
const MACHINE_GUN_COOLDOWN: float = 0.4
const MACHINE_GUN_SPEED_PERCENTAGE: float = 1.5
const MACHINE_GUN_DAMAGE_PERCENTAGE: float = 0.15
var MACHINE_GUN_IMAGE: Texture = load("res://sprites/towers/sentry/machine_gun/f1.png")
const MACHINE_GUN_SCENE_PATH: String = "res://towers/sentry/rapid/MachineGunTower.tscn"

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
var SHOOTER_SPAWNER_IMAGE: Texture = load("res://sprites/towers/spawner/spawner.png")
const SHOOTER_SPAWNER_SCENE_PATH: String = "res://towers/spawner/ShooterSpawnerTower.tscn"

const BLANK_COST: int = 10
const BLANK_NAME: String = "Blank"
const BLANK_DESCRIPTION: String = "Does nothing"
var BLANK_IMAGE: Texture = load("res://sprites/player/white.png")
const BLANK_SCENE_PATH: String = "res://towers/blank/BlankTower.tscn"

const GOLD_DISPENSER_NAME: String = "Gold Dispenser"
const GOLD_DISPENSER_COST: int = 10
const GOLD_DISPENSER_COOLDOWN: float = 15
const GOLD_DISPENSER_DESCRIPTION: String = "Dispenses gold"
var GOLD_DISPENSER_IMAGE: Texture = load("res://sprites/towers/blank/economy/gold_dispenser.png")
const GOLD_DISPENSER_SCENE_PATH: String = "res://towers/blank/economy/GoldDispenserTower.tscn"

const PYLON_NAME: String = "Pylon"
const PYLON_DESCRIPTION: String = "Creates an electric fence between pylons"
const PYLON_SCENE_PATH: String = "res://towers/blank/pylon/PylonTower.tscn"
const PYLON_COST: int = 10
const PYLON_COOLDOWN: float = 0.25
const PYLON_DAMAGE: float = 0.1
var PYLON_IMAGE: Texture = load("res://sprites/player/white.png")

const SLOWING_PYLON_NAME: String = "Slowing Pylon"
const SLOWING_PYLON_DESCRIPTION: String = "Slows enemy bullets that enter this tower's area"
const SLOWING_PYLON_SCENE_PATH: String = "res://towers/blank/pylon/slowing/SlowingPylonTower.tscn"
const SLOWING_PYLON_COST: int = 15
const SLOWING_PYLON_COOLDOWN: float = 0.25
const SLOWING_PYLON_DAMAGE: float = 0.15
var SLOWING_PYLON_IMAGE: Texture = load("res://sprites/player/white.png")

var charger_minion_scene: PackedScene = load("res://towers/spawner/minions/ChargerMinion.tscn")
const CHARGER_NAME: String = "Charger"
const CHARGER_SPEED: float = 100
const CHARGER_DAMAGE: float = 0.8
const CHARGER_WANDER_DIST: float = 300
const CHARGER_MIN_WANDER: float = 50
const CHARGER_LIFETIME: float = 5

var shooter_minion_scene: PackedScene = load("res://towers/spawner/minions/ShooterMinion.tscn")
const SHOOTER_NAME: String = "Shooter"
const SHOOTER_SPEED: float = 100
const SHOOTER_DAMAGE: float = 0.4
const SHOOTER_COOLDOWN: float = 1.5
const SHOOTER_PROJECTILE_SPEED: float = 0.5
const SHOOTER_WANDER_DIST: float = 300
const SHOOTER_MIN_WANDER: float = 100
const SHOOTER_BULLET_SCALE: float = 0.5

const end_of_path_name: String = "End of path"
var end_of_path_image: Texture = load("res://sprites/towers/lock.png")
const end_of_path_cost: String = "N/A"
