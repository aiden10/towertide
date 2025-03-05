extends Node

const xp1 = preload("res://resources/sounds/xp2.wav")
const xp2 = preload("res://resources/sounds/xp1.wav")
const gold1 = preload("res://resources/sounds/gold1.wav")
const death1 = preload("res://resources/sounds/death1.wav")
const shoot = preload("res://resources/sounds/shoot.wav")
const hit = preload("res://resources/sounds/hit.wav")
const minion1 = preload("res://resources/sounds/minion1.wav")

const SOUNDS = {
	"purchase": preload("res://resources/sounds/purchase.wav"),
	"bell_toll": preload("res://resources/sounds/bell.wav"),
	"thump": preload("res://resources/sounds/thump.wav"),
	"invalid": preload("res://resources/sounds/invalid.wav"),
	"player_hit": preload("res://resources/sounds/player_hit.wav"),
	"deflect": preload("res://resources/sounds/deflect.wav"),
	"sword_purchased": preload("res://resources/sounds/sword_purchased.wav"),
	"level_up": preload("res://resources/sounds/level_up.wav"),
	"reroll": preload("res://resources/sounds/reroll.wav"),
	"sword": preload("res://resources/sounds/sword.wav"),
	"enter": preload("res://resources/sounds/enter.wav"),
	"thud": preload("res://resources/sounds/thud.wav"),
	"heal": preload("res://resources/sounds/heal.wav"),
	"select": preload("res://resources/sounds/select.wav"),
	"upgrade": preload("res://resources/sounds/upgrade.wav"),
	"sold": preload("res://resources/sounds/sold.wav"),
	"slot_play": preload("res://resources/sounds/slot_play.wav"),
	"slot_win": preload("res://resources/sounds/slot_win.wav"),
	"slot_lost": preload("res://resources/sounds/slot_lose.wav"),
	"slot_jackpot": preload("res://resources/sounds/slot_jackpot.wav"),
	"button_press": preload("res://resources/sounds/button_press.wav")
}

const XP_SOUNDS = [xp1, xp2]
const GOLD_SOUNDS = [gold1]
const DEATH_SOUNDS = [death1]
const SHOOT_SOUNDS = [shoot]
const ENEMY_HIT_SOUNDS = [hit]
const MINION_SOUNDS = [minion1]

var audio_players: Array[AudioStreamPlayer] = []
var sound_level: float = 100.0
const POOL_SIZE = 16

func _ready() -> void:
	for i in POOL_SIZE:
		var player = AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)

	EventBus.purchased.connect(func(): play_sound("purchase"))
	EventBus.extra_spawn.connect(func(): play_sound("bell_toll"))
	EventBus.tower_placed.connect(func(): play_sound("thump"))
	EventBus.player_hit.connect(func(): play_sound("player_hit"))
	EventBus.deflect.connect(func(): play_sound("deflect"))
	EventBus.sword_purchased.connect(func(): play_sound("sword_purchased"))
	EventBus.level_up.connect(func(): play_sound("level_up"))
	EventBus.invalid_action.connect(func(): play_sound("invalid"))
	EventBus.rerolled.connect(func(): play_sound("reroll"))
	EventBus.sword_hit.connect(func(): play_sound("sword"))
	EventBus.level_exited.connect(func(): play_sound("enter"))
	EventBus.level_cleared.connect(func(): play_sound("thud"))
	EventBus._wave_started.connect(func(): play_sound("bell_toll"))
	EventBus.player_regenerated.connect(func(): play_sound("heal", -25))
	EventBus._tower_upgraded.connect(func(): play_sound("upgrade", -35))
	EventBus.tower1_selected.connect(func(): play_sound("select"))
	EventBus.tower2_selected.connect(func(): play_sound("select"))
	EventBus.tower3_selected.connect(func(): play_sound("select"))
	EventBus.tower4_selected.connect(func(): play_sound("select"))
	EventBus.tower_sold.connect(func(): play_sound("sold"))
	EventBus._slots_start.connect(func(): play_sound("slot_play"))
	EventBus._slots_won.connect(func(): play_sound("slot_win"))
	EventBus._slots_lost.connect(func(): play_sound("slot_lost"))
	EventBus._slots_jackpot.connect(func(): play_sound("slot_jackpot"))
	EventBus._button_pressed.connect(func(): play_sound("button_press"))
	
	EventBus.xp_picked_up.connect(func(_xp_type: int): play_random(XP_SOUNDS))
	EventBus.gold_picked_up.connect(func(): play_random(GOLD_SOUNDS))
	EventBus.enemy_dead.connect(func(): play_random(DEATH_SOUNDS))
	EventBus.enemy_hit.connect(func(): play_random(ENEMY_HIT_SOUNDS))
	EventBus.player_shot.connect(func(): play_random(SHOOT_SOUNDS))
	EventBus.enemy_shot.connect(func(): play_random(SHOOT_SOUNDS))
	EventBus.tower_shot.connect(func(): play_random(SHOOT_SOUNDS))
	EventBus.minion_spawned.connect(func(): play_random(MINION_SOUNDS, -10))
	
func set_master_volume() -> void:
	var normalized_volume = _get_normalized_volume(sound_level)
	for player in audio_players:
		player.volume_db = normalized_volume

func _get_normalized_volume(slider_value: float) -> float:
	var normalized = slider_value / 100.0
	var curved_volume = pow(normalized, 2)  # Quadratic curve    
	var volume_db = linear_to_db(curved_volume)
	return min(volume_db, 0.0)

func play_random(sounds: Array, volume_adjustment: float = 0.0) -> void:
	var player = _get_available_player()
	if player:
		player.stream = sounds.pick_random()
		player.volume_db = _get_normalized_volume(sound_level + volume_adjustment)
		player.play()

func play_sound(sound_name: String, volume_adjustment: float = 0.0) -> void:
	var player = _get_available_player()
	if player:
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		player.stream = SOUNDS[sound_name]
		player.volume_db = _get_normalized_volume(sound_level + volume_adjustment)
		player.play()

func _get_available_player() -> AudioStreamPlayer:
	for player in audio_players:
		if not player.playing:
			return player
	return null
	
