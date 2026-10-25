shader_type canvas_item;
uniform float motion : hint_range(0.0, 1.0) = 1.0;
void fragment() {
    vec2 uv = UV;
    uv.x += sin(uv.y * 38.0 - TIME * 3.0 * motion) * 0.0015 * motion;
    vec4 water = texture(TEXTURE, clamp(uv, vec2(0.0), vec2(1.0)));
    float shimmer = 0.97 + 0.03 * sin(uv.y * 46.0 - TIME * 4.0 * motion);
    COLOR = vec4(water.rgb * shimmer, water.a) * COLOR;
}
