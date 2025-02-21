extends Node2D

@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	particles.emitting = true
	
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()

func set_color(color: Color) -> void:
	particles.process_material.color = color
