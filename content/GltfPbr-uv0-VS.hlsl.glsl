#version 450

struct Light
{
    mat4 VpXf;
    mat4 ViewXf;
    vec3 v3DirectionW;
    float fRange;
    vec3 rgbColor;
    float fIntensity;
    vec3 Pw;
    float fInnerConeCos;
    float fOuterConeCos;
    int type_;
    float fDepthBias;
    int iShadowMap;
};

struct VsIn
{
    vec3 Pobj;
    vec3 Nobj;
    vec2 uv0;
};

struct VsOut
{
    vec4 Pclip;
    vec3 Pw;
    vec3 Nw;
    vec2 uv0;
};

layout(set = 0, binding = 0, std140) uniform type_cbPerFrame
{
    layout(row_major) mat4 g_VpXf;
    layout(row_major) mat4 g_prevVpXf;
    layout(row_major) mat4 g_VpIXf;
    vec3 g_cameraPw;
    float g_cameraPw_fPadding;
    float g_fIblFactor;
    float g_fPerFrameEmissiveFactor;
    vec2 g_fInvScreenResolution;
    vec4 g_f4WireframeOptions;
    vec2 g_f2MCameraCurrJitter;
    vec2 g_f2MCameraPrevJitter;
    layout(row_major) Light g_lights[80];
    int g_nLights;
    float g_lodBias;
} cbPerFrame;

layout(set = 0, binding = 1, std140) uniform type_cbPerObject
{
    layout(row_major) mat3x4 g_WorldXf;
    layout(row_major) mat3x4 g_prevWorldXf;
} cbPerObject;

layout(location = 0) in vec3 in_var_POSITION;
layout(location = 1) in vec3 in_var_NORMAL;
layout(location = 2) in vec2 in_var_TEXCOORD;
layout(location = 0) out vec3 out_var_TEXCOORD0;
layout(location = 1) out vec3 out_var_TEXCOORD1;
layout(location = 2) out vec2 out_var_TEXCOORD2;

VsOut src_main(VsIn vsIn)
{
    vec3 Pw = vec4(vsIn.Pobj, 1.0) * cbPerObject.g_WorldXf;
    VsOut vsOut;
    vsOut.Pclip = vec4(Pw, 1.0) * cbPerFrame.g_VpXf;
    vsOut.Pw = Pw;
    vsOut.Nw = normalize(vec4(vsIn.Nobj, 0.0) * cbPerObject.g_WorldXf);
    vsOut.uv0 = vsIn.uv0;
    return vsOut;
}

void main()
{
    VsIn param_var_vsIn = VsIn(in_var_POSITION, in_var_NORMAL, in_var_TEXCOORD);
    VsOut _49 = src_main(param_var_vsIn);
    gl_Position = _49.Pclip;
    out_var_TEXCOORD0 = _49.Pw;
    out_var_TEXCOORD1 = _49.Nw;
    out_var_TEXCOORD2 = _49.uv0;
}

