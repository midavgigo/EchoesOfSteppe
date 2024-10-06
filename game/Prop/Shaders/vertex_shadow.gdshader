shader_type canvas_item;

void fragment() {
	vec3 input_color = texture(TEXTURE, UV).rgb;
	input_color *= 1.0-length(vec2(1, 1)-UV);
	COLOR.rgb = input_color;
}
