// 文档 https://github.com/hooke007/MPV_lazy/wiki/4_GLSL


//!PARAM X
//!TYPE float
//!MINIMUM 0.0
//!MAXIMUM 100.0
50.0

//!PARAM Y
//!TYPE float
//!MINIMUM 0.0
//!MAXIMUM 100.0
50.0

//!PARAM A
//!TYPE float
//!MINIMUM 0.0
//!MAXIMUM 100.0
0.0

//!PARAM B
//!TYPE float
//!MINIMUM 0.0
//!MAXIMUM 100.0
0.0

//!PARAM SHAPE
//!TYPE int
//!MINIMUM 1
//!MAXIMUM 2
1

//!PARAM SOFT
//!TYPE float
//!MINIMUM 0.0
//!MAXIMUM 10.0
1.0

//!PARAM ALT
//!TYPE int
//!MINIMUM 0
//!MAXIMUM 1
0


//!HOOK OUTPUT
//!BIND HOOKED
//!DESC [harmony_RT]

vec4 hook() {

	vec4 color = HOOKED_tex(HOOKED_pos);
	vec2 center = vec2(X, Y) / 100.0;
	vec2 size = vec2(A, B) / 100.0;
	vec2 pos = HOOKED_pos.xy;
	float feather = SOFT / 10.0;
	float dist = 0.0;

	if (SHAPE == 1) {
		float d_l = pos.x - (center.x - size.x);
		float d_r = (center.x + size.x) - pos.x;
		float d_t = pos.y - (center.y - size.y);
		float d_b = (center.y + size.y) - pos.y;
		dist = min(min(d_l, d_r), min(d_t, d_b));
	} else if (SHAPE == 2) {
		vec2 relative_pos = (pos - center) / size;
		float r = length(relative_pos);
		dist = 1.0 - r;
	}

	float in_region = 1.0;
	float feather_rad = (SHAPE == 1) ? feather * 0.1 : feather;
	in_region = smoothstep(-feather_rad, feather_rad, dist);

	float black_factor = (ALT == 0) ? in_region : (1.0 - in_region);
	return mix(color, vec4(vec3(0.0), color.a), black_factor);

}

