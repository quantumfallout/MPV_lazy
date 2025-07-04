// 文档 https://github.com/hooke007/MPV_lazy/wiki/4_GLSL


//!PARAM dT
//!TYPE float
//!MINIMUM 0.0
//!MAXIMUM 2.0
0.0

//!PARAM dB
//!TYPE float
//!MINIMUM 0.0
//!MAXIMUM 2.0
0.0

//!PARAM dL
//!TYPE float
//!MINIMUM 0.0
//!MAXIMUM 2.0
0.0

//!PARAM dR
//!TYPE float
//!MINIMUM 0.0
//!MAXIMUM 2.0
0.0

//!PARAM LV
//!TYPE float
//!MINIMUM 0.0
//!MAXIMUM 2.0
1.0


//!HOOK OUTPUT
//!BIND HOOKED
//!DESC [darkside_RT]
//!WHEN dT dB + dL + dR + LV *

vec4 hook() {

	vec2 uv = gl_FragCoord.xy / HOOKED_size;
	vec4 color = HOOKED_tex(HOOKED_pos);

	float factor_t = smoothstep(0.0, dT, uv.y);
	float factor_b = smoothstep(0.0, dB, 1.0 - uv.y);
	float factor_l = smoothstep(0.0, dL, uv.x);
	float factor_r = smoothstep(0.0, dR, 1.0 - uv.x);

	float factor4 = factor_t * factor_b * factor_l * factor_r;
	float factor_a = mix((2.0 - LV) * 0.5, 1.0, factor4);

	return vec4(color.rgb * factor_a, color.a * factor_a);

}

