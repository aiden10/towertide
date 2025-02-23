extends Node

const SOUNDS = {}
var audio_players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	EventBus.purchased.connect(func(): play_sound("purchase"))

func play_sound(sound_name: String) -> void:
	var player = _get_available_player()
	if player:
		player.stream = SOUNDS[sound_name]
		player.play()

func _get_available_player() -> AudioStreamPlayer:
	for player in audio_players:
		if not player.playing:
			return player
	return null
	
