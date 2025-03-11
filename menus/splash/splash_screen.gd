extends Control
@onready var ag_button: TextureButton = $AGButton
@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var timeout_timer: Timer

func _ready() -> void:
	ag_button.pressed.connect(func(): OS.shell_open("https://armor.ag/MoreGames"))
	video_player.finished.connect(SceneManager.load_main_menu)
	
	timeout_timer = Timer.new()
	timeout_timer.wait_time = 5 + 0.5
	timeout_timer.one_shot = true
	timeout_timer.timeout.connect(SceneManager.load_main_menu)
	add_child(timeout_timer)
	timeout_timer.start()
	
	if OS.get_name() == "Web":
		var check_timer = Timer.new()
		check_timer.wait_time = 0.1
		check_timer.timeout.connect(_check_video_ended)
		add_child(check_timer)
		check_timer.start()

func _check_video_ended():
	# If video has reached its end but the signal hasn't fired
	if video_player.stream and !video_player.is_playing() and video_player.get_playback_position() > 0:
		SceneManager.load_main_menu()
