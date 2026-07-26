shader_type canvas_item;

uniform vec2 scroll = vec2(0.0);
uniform vec2 repeat = vec2(1.0);

void fragment() {
	vec2 uv = UV * repeat;
	uv += scroll;
	COLOR = texture(TEXTURE, fract(uv));
}
