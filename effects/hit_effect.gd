extends Node2D

@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	particles.emitting = true
	
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()

func set_properties(color: Color, damage: float) -> void:
	if not is_node_ready():
		await ready
	var new_material = particles.process_material.duplicate()
	new_material.color = color
	self.scale *= log(damage) / 2
	particles.process_material = new_material
