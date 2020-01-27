shader_type canvas_item;

uniform int passes = 60;

void fragment()
{
	ivec2 texSize = textureSize(TEXTURE, 0);
	float 	minus1x = float(-1) / float(texSize.x), 
			plus1x = float(1) / float(texSize.x), 
			minus1y = float(-1) / float(texSize.y), 
			plus1y = float(1) / float(texSize.y);
	
	vec4 samplesCombined;
	
	for (int i = 0; i < passes; i++) {
		vec4 sample1 = texture(TEXTURE, UV + vec2(minus1x, minus1y));
		vec4 sample2 = texture(TEXTURE, UV + vec2(minus1x, 0.0));
		vec4 sample3 = texture(TEXTURE, UV + vec2(minus1x, plus1y));
		vec4 sample4 = texture(TEXTURE, UV + vec2(0.0, minus1y));
		vec4 sample = texture(TEXTURE, UV);
		vec4 sample5 = texture(TEXTURE, UV + vec2(0.0, plus1y));
		vec4 sample6 = texture(TEXTURE, UV + vec2(plus1x, minus1y));
		vec4 sample7 = texture(TEXTURE, UV + vec2(plus1x, 0.0));
		vec4 sample8 = texture(TEXTURE, UV +vec2(plus1x, plus1y));
		samplesCombined += (sample1 + sample2 + sample3 + sample4 + sample5 + sample6 + sample7 + sample8 + sample);
	}
	COLOR = samplesCombined / (9.0 * float(passes));
}