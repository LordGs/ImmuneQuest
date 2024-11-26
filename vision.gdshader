shader_type canvas_item;

uniform float outerRadius : hint_range(0.0, 5.0) = 1.0;
uniform float smoothness : hint_range(0.0, 5.0) = 1.0; // Allow smoothness to go beyond 1.0
uniform float MainAlpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    float x = abs(UV.x - 0.5) * 2.0;
    float y = abs(UV.y - 0.5) * 2.0;
    float distance = sqrt((x * x) + (y * y));

    // Use the smoothness parameter to control the transition
    float v = smoothstep(outerRadius, outerRadius - smoothness, distance); // Smoothness control

    // Invert the value to have black in the center
    v = 1.0 - v;

    COLOR = vec4(0, 0, 0, v * MainAlpha); // Black color with smooth gradient
}
