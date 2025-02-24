extends Node

const CROSS_COST: int = 5
const CROSS_NAME: String = "Cross"
const CROSS_COOLDOWN: float = 2.5
const CROSS_SPEED_PERCENTAGE: float = 0.5 
const CROSS_DAMAGE_PERCENTAGE: float = 0.5 
var CROSS_IMAGE: Texture = load("res://sprites/towers/cross/f1.png")
const CROSS_SCENE_PATH: String = "res://towers/cross/CrossTower.tscn"

const SENTRY_COST: int = 10
const SENTRY_NAME: String = "Sentry"
const SENTRY_COOLDOWN: float = 1.25
const SENTRY_SPEED_PERCENTAGE: float = 0.8 
const SENTRY_DAMAGE_PERCENTAGE: float = 0.4
var SENTRY_IMAGE: Texture = load("res://sprites/towers/sentry/sentry.png")
const SENTRY_SCENE_PATH: String = "res://towers/sentry/SentryTower.tscn"

const SPAWNER_COST: int = 15
const SPAWNER_SPAWN_AMOUNT: int = 2
const SPAWNER_NAME: String = "Spawner"
const SPAWNER_COOLDOWN: float = 2.5
const SPAWNER_SPEED_PERCENTAGE: float = 0.5 
const SPAWNER_DAMAGE_PERCENTAGE: float = 0.15
const SPAWNER_LIMIT: int = 3
var SPAWNER_IMAGE: Texture = load("res://sprites/towers/spawner/spawner.png")
const SPAWNER_SCENE_PATH: String = "res://towers/spawner/SpawnerTower.tscn"

var charger_minion_scene: PackedScene = load("res://towers/spawner/minions/ChargerMinion.tscn")
const CHARGER_SPEED: float = 100
const CHARGER_DAMAGE: float = 0.8
const CHARGER_WANDER_DIST: float = 300
const CHARGER_MIN_WANDER: float = 50
const MINION_LIFETIME: float = 4

const end_of_path_name: String = "End of path"
var end_of_path_image: Texture = load("res://sprites/towers/lock.png")
const end_of_path_cost: String = "N/A"
