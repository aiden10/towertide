extends Node

const CROSS_COST: int = 5
const CROSS_NAME: String = "Cross"
const CROSS_COOLDOWN: float = 2
const CROSS_SPEED_PERCENTAGE: float = 0.5 
const CROSS_DAMAGE_PERCENTAGE: float = 0.5 
var CROSS_IMAGE: Texture = load("res://sprites/towers/cross/f1.png")

const SENTRY_COST: int = 10
const SENTRY_NAME: String = "Sentry"
const SENTRY_COOLDOWN: float = 0.5
const SENTRY_SPEED_PERCENTAGE: float = 0.5 
const SENTRY_DAMAGE_PERCENTAGE: float = 0.25 
var SENTRY_IMAGE: Texture = load("res://sprites/towers/sentry/sentry.png")

const SPAWNER_COST: int = 20
const SPAWNER_SPAWN_AMOUNT: int = 1
const SPAWNER_NAME: String = "Sentry"
const SPAWNER_COOLDOWN: float = 3
const SPAWNER_SPEED_PERCENTAGE: float = 0.5 
const SPAWNER_DAMAGE_PERCENTAGE: float = 0.25 
var SPAWNER_IMAGE: Texture = load("res://sprites/towers/sentry/sentry.png")

var CHARGER_MINION_SCENE: PackedScene = load("res://towers/spawner/minions/ChargerMinion.tscn")
const CHARGER_SPEED: float = 100
const CHARGER_DAMAGE: float = 0.8
const CHARGER_WANDER_DIST: float = 200
const CHARGER_MIN_WANDER: float = 50

const end_of_path_name: String = "End of path"
var end_of_path_image: Texture = load("res://sprites/towers/lock.png")
const end_of_path_cost: String = "N/A"
