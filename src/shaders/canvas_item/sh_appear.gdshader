shader_type canvas_item;

uniform float multiplier:hint_range(0.0, 1.0);

void fragment() {
	vec2 new_uv = UV + vec2(sin(TIME + (UV.y * 100.0 * multiplier )) * multiplier, UV.y *  multiplier);
	vec4 new_tex = texture(TEXTURE, new_uv);
	
	vec4 new_color = vec4(new_tex.r, new_tex.g, new_tex.b, new_tex.a - multiplier);
	
	COLOR = new_color;
}
