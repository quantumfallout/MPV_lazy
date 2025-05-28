
//!PARAM Y
//!TYPE DEFINE
//!DESC float
//!MINIMUM -100.0
//!MAXIMUM 100.0
0.0

//!DESC [pan_RT]
//!HOOK MAINPRESUB
//!BIND HOOKED
//!WHEN Y 0.0 = !

float offset_pct = 0.01 * Y;

vec4 hook()
{
	float height = HOOKED_size.y;
	float offset = height * offset_pct;
	float abs_offset = abs(offset);
	vec2 texcoord = HOOKED_pos * HOOKED_size;

#if (Y > 0)
	if(texcoord.y < abs_offset) return vec4(0.0);
	return HOOKED_texOff(vec2(0, -abs_offset));
#elif (Y < 0)
	if(texcoord.y > (height - abs_offset)) return vec4(0.0);
	return HOOKED_texOff(vec2(0, abs_offset));
#endif

}

