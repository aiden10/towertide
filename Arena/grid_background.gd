# Add this script to your ColorRect background node
extends ColorRect

# These will be set automatically or can be adjusted in the Inspector
@export var grid_size: float = 64.0
@export var grid_color: Color = Color(0.2, 0.2, 0.2)
@export var background_color: Color = Color(0.1, 0.1, 0.1)
@export var line_thickness: float = 0.01

func _ready():		
	material.set_shader_parameter("grid_size", grid_size)
	material.set_shader_parameter("grid_color", grid_color)
	material.set_shader_parameter("background_color", background_color)
	material.set_shader_parameter("line_thickness", line_thickness)

func _process(_delta):
	var viewport = get_viewport()
	if viewport and material:
		var camera = viewport.get_camera_2d()
		if camera:
			position.x = camera.global_position.x - 1250
			position.y = camera.global_position.y - 1250
			material.set_shader_parameter("camera_position", camera.global_position)
			material.set_shader_parameter("screen_size", viewport.get_visible_rect().size)
