// 文档 https://github.com/hooke007/MPV_lazy/wiki/4_GLSL


//!DESC [colorlevel_expand_chroma]
//!HOOK CHROMA
//!BIND HOOKED

const float min = 16.0 / 255.0;
const float max = 255.0 / (240.0 - 16.0);

vec4 hook()
{
    return (HOOKED_texOff(0) - min) * max;
}

