// 文档 https://github.com/hooke007/MPV_lazy/wiki/4_GLSL


//!PARAM Rx
//!TYPE float
0.0

//!PARAM Ry
//!TYPE float
0.0

//!PARAM Gx
//!TYPE float
0.0

//!PARAM Gy
//!TYPE float
0.0

//!PARAM Bx
//!TYPE float
0.0

//!PARAM By
//!TYPE float
0.0


//!HOOK MAINPRESUB
//!BIND HOOKED
//!DESC [plane_shift_rgb_RT]
//!WHEN Rx Ry + Gx + Gy + Bx + By +

vec4 hook() {

	vec2 pos = HOOKED_pos;
	vec2 pixel_size = 1.0 / HOOKED_size;
	vec2 pos_r = vec2(pos.x - Rx * pixel_size.x, pos.y - Ry * pixel_size.y);
	vec2 pos_g = vec2(pos.x - Gx * pixel_size.x, pos.y - Gy * pixel_size.y);
	vec2 pos_b = vec2(pos.x - Bx * pixel_size.x, pos.y - By * pixel_size.y);
	float r = 0.0;
	float g = 0.0;
	float b = 0.0;

	if (pos_r.x >= 0.0 && pos_r.x <= 1.0 && pos_r.y >= 0.0 && pos_r.y <= 1.0) {
		r = HOOKED_tex(pos_r).r;
	}
	if (pos_g.x >= 0.0 && pos_g.x <= 1.0 && pos_g.y >= 0.0 && pos_g.y <= 1.0) {
		g = HOOKED_tex(pos_g).g;
	}
	if (pos_b.x >= 0.0 && pos_b.x <= 1.0 && pos_b.y >= 0.0 && pos_b.y <= 1.0) {
		b = HOOKED_tex(pos_b).b;
	}
	float a = HOOKED_tex(pos).a;

	return vec4(r, g, b, a);

}

