shader_type canvas_item;

uniform float size = 1.0;

void fragment()
{	
	vec2 texSize = TEXTURE_PIXEL_SIZE * size;
	vec4 sample0 = texture(TEXTURE, UV) * 0.2270270270;
	
	vec4 sample3 = texture(TEXTURE, UV + vec2(0.0, -3.2307692308) * texSize) * 0.0702702703;
	vec4 sample4 = texture(TEXTURE, UV + vec2(0.0, -1.3846153846) * texSize) * 0.3162162162;
	vec4 sample5 = texture(TEXTURE, UV + vec2(0.0, 1.3846153846) * texSize) * 0.3162162162;
	vec4 sample6 = texture(TEXTURE, UV + vec2(0.0, 3.2307692308) * texSize) * 0.0702702703;
	
	vec4 sample11 = texture(TEXTURE, UV + vec2(-3.2307692308, 0.0) * texSize) * 0.1216216216;
	vec4 sample12 = texture(TEXTURE, UV + vec2(-1.3846153846, 0.0) * texSize) * 0.1945945946;
	vec4 sample13 = texture(TEXTURE, UV + vec2(1.3846153846, 0.0) * texSize) *  0.1945945946;
	vec4 sample14 = texture(TEXTURE, UV + vec2(3.2307692308, 0.0) * texSize) * 0.1216216216;
	
	if(sample3.a < 1e-4) sample3 = vec4(0.0);
	if(sample4.a < 1e-4) sample4 = vec4(0.0);
	if(sample5.a < 1e-4) sample5 = vec4(0.0);
	if(sample6.a < 1e-4) sample6 = vec4(0.0);
	
	vec4 frag =
			  sample0
			+ sample3
			+ sample4
			+ sample5
			+ sample6;
//	frag += 
//			  sample11 * 0.1216216216
//			+ sample12 * 0.1945945946
//			+ sample13 * 0.1945945946
//			+ sample14 * 0.1216216216;
	
	COLOR = frag;
}