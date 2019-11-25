shader_type canvas_item;

uniform int width : hint_range(0, 10);
uniform float fade_intencity;
uniform vec4 color : hint_color;
uniform vec4 color2 : hint_color;
uniform float speed;

//outline shader
void fragment() 
{
	int halfWidth = width / 2;
	vec4 sprite_color = texture(TEXTURE, UV);
	float texSizeX = float(width) / float(textureSize(TEXTURE, 0).x);
	float texSizeY = float(width) / float(textureSize(TEXTURE, 0).y);
	
	if (sprite_color.a > 0.3) {
		COLOR = sprite_color;
	} else {	
		float alpha = 0.;
		for (int i =- halfWidth; i <= halfWidth; i += 1) {		
			for (int j =- halfWidth; j <= halfWidth; j += 1) {
				vec4 sample = texture(TEXTURE, UV + vec2(float(i) * texSizeX, float(j) * texSizeY));
				alpha += sample.a * fade_intencity;
			}
		}
		vec3 outlineColor = mix(color.rgb, color2.rgb, sin(TIME * speed));
		COLOR = vec4(outlineColor, alpha);	
	}
}