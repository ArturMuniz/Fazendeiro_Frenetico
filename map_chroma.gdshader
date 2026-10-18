shader_type canvas_item;
render_mode unshaded;
varying vec4 vertex_tint;

void vertex() {
	vertex_tint = COLOR;
}

void fragment() {
	// JPEG chroma key, including the purple fringe. Grass, fruit and wood stay intact.
	vec4 texel = texture(TEXTURE, UV);
	if (texel.a < 0.875 || (texel.r > texel.g * 1.45 + 0.0588 && texel.b > texel.g * 1.45 + 0.0588 && min(texel.r, texel.b) > 0.196)) {
		COLOR = vec4(0.0);
	} else {
		COLOR = vec4(texel.rgb, 1.0) * vertex_tint;
	}
}
