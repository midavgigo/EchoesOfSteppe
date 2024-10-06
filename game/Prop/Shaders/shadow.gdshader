shader_type canvas_item;
uniform sampler2D gradient:hint_default_black;

void fragment(){
	vec4 input_color = texture(TEXTURE, UV);
	vec4 gradient_color = texture(gradient, UV);
	input_color.rgb *= gradient_color.a;
	COLOR.rgb = input_color.rgb;
}
