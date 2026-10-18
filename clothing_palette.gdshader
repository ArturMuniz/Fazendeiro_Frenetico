shader_type canvas_item;
render_mode unshaded;
uniform float source_hue = 0.6;
uniform float target_hue = 0.075;

vec3 rgb_to_hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + 1.0e-10)), d / (q.x + 1.0e-10), q.x);
}

vec3 hsv_to_rgb(vec3 c) {
	vec3 p = abs(fract(c.xxx + vec3(0.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0);
	return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

varying vec4 vertex_tint;
void vertex() { vertex_tint = COLOR; }
void fragment() {
	vec4 texel = texture(TEXTURE, UV);
	vec3 hsv = rgb_to_hsv(texel.rgb);
	float distance_hue = min(abs(hsv.x - source_hue), 1.0 - abs(hsv.x - source_hue));
	// Original outline, skin, hair, neutral tools and transparent pixels stay intact.
	if (texel.a > 0.0 && distance_hue < 0.095 && hsv.y > 0.18 && hsv.z > 0.16) {
		hsv.x = fract(hsv.x + target_hue - source_hue + 1.0);
		texel.rgb = hsv_to_rgb(hsv);
	}
	COLOR = texel * vertex_tint;
}
