extends PanelContainer

func _ready() -> void:
	EventBus.pause_game.connect(func(): self.visible = true)
	EventBus.unpause_game.connect(func(): self.visible = false)
