shader_type canvas_item;

uniform float wind_speed;
uniform float wind_strength;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	 
	vec2 new_uv = UV + vec2(sin(TIME + UV.y * wind_speed) * ((1.0 - UV.y) * wind_strength), 0.0);
	
	vec4 new_tex = texture(TEXTURE, new_uv);
	COLOR = new_tex;
}
