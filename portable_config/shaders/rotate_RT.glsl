
//!PARAM ROT
//!TYPE float
//!MINIMUM -360.0
//!MAXIMUM 360.0
0.0

//!PARAM FIT
//!TYPE int
//!MINIMUM 0
//!MAXIMUM 1
1

//!HOOK MAINPRESUB
//!BIND HOOKED
//!DESC [rotate_RT]
//!WHEN ROT

vec4 hook() {

	vec2 pos = HOOKED_pos;
	vec2 size = HOOKED_size;
	vec2 align = vec2(0.5, 0.5);
	pos -= align;

	float aspect_ratio = size.x / size.y;
	float angle = radians(ROT);
	float cos_a = cos(angle);
	float sin_a = sin(angle);
	float scale_factor = 1.0;
	if (FIT == 1) {
		float abs_cos = abs(cos_a);
		float abs_sin = abs(sin_a);
		float new_width = aspect_ratio * abs_cos + 1.0 * abs_sin;
		float new_height = aspect_ratio * abs_sin + 1.0 * abs_cos;
		float zoom_factor = max(new_width / aspect_ratio, new_height / 1.0);
		scale_factor = 1.0 / zoom_factor;
	}

	pos /= scale_factor;
	pos.x *= aspect_ratio;
	mat2 rotation_matrix = mat2(
		cos_a, -sin_a,
		sin_a,  cos_a
	);
	pos = rotation_matrix * pos;
	pos.x /= aspect_ratio;
	pos += align;

	if (any(lessThan(pos, vec2(0.0))) || any(greaterThan(pos, vec2(1.0)))) {
		return vec4(0.0);
	}

	return HOOKED_tex(pos);

}

