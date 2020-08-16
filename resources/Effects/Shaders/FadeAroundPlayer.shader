shader_type canvas_item;

uniform vec2 center = vec2(19, 10);
uniform float fadeAwayStrength = 10;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	float sqrt2 = 1.4142135;
	float 	screenX = SCREEN_UV.x - 0.5, 
			screenY = SCREEN_UV.y - 0.5;
		
	float alpha = screenX * screenX / sqrt2 + screenY * screenY / sqrt2;
	float alpha2 = 1.0 - length(UV - center) / fadeAwayStrength;
	alpha2 = max(0.0, alpha2);
	
	alpha = min(alpha, color.a);
	alpha = min(alpha, alpha2);
	
	color.a = alpha;
	
	COLOR = color;
}
