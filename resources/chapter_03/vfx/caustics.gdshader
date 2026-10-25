shader_type canvas_item;
render_mode unshaded, blend_add;
uniform vec4 tint : source_color = vec4(0.208, 0.851, 1.0, 1.0);
uniform float strength : hint_range(0.0, 0.25) = 0.065;
uniform float motion : hint_range(0.0, 1.0) = 1.0;
void fragment() {
    // The archive is a technical sheet, not a verified seamless texture.
    // Mirror each axis at its boundary so repeating samples meet continuously.
    vec2 drift = vec2(0.014, -0.009) * TIME * motion;
    vec2 mirrored = 1.0 - abs(mod((UV + drift) * 2.0, 2.0) - 1.0);
    float intensity = texture(TEXTURE, mirrored).r;
    COLOR = vec4(tint.rgb * intensity, intensity * strength);
}
