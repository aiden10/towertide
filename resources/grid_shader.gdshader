shader_type canvas_item;

uniform vec4 grid_color : source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform vec4 background_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform float line_thickness : hint_range(0.001, 0.05) = 0.01;
uniform float grid_size : hint_range(10.0, 200.0) = 64.0;
uniform vec2 camera_position = vec2(0.0, 0.0);
uniform vec2 screen_size = vec2(1152.0, 648.0);

void fragment() {
    // Calculate world position based on screen position and camera position
    vec2 screen_pos = SCREEN_UV * screen_size;
    vec2 world_pos = screen_pos + camera_position - (screen_size / 2.0);

    // Create grid coordinates based on world position
    vec2 grid_coords = world_pos / grid_size;

    // Generate grid
    vec2 frac_coords = fract(grid_coords);
    vec2 grid_lines = step(1.0 - line_thickness, frac_coords) +
                      step(frac_coords, vec2(line_thickness));
    float is_grid = min(1.0, grid_lines.x + grid_lines.y);

    // Mix background and grid colors
    COLOR = mix(background_color, grid_color, is_grid);
}