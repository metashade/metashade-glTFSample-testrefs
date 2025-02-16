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
    vec4 Tobj;
    vec2 uv0;
};

struct VsOut
{
    vec4 Pclip;
    vec3 Pw;
    vec3 Nw;
    vec3 Tw;
    vec3 Bw;
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
    layout(row_major) Light g_light0;
    layout(row_major) Light g_light1;
    layout(row_major) Light g_light2;
    layout(row_major) Light g_light3;
    layout(row_major) Light g_light4;
    layout(row_major) Light g_light5;
    layout(row_major) Light g_light6;
    layout(row_major) Light g_light7;
    layout(row_major) Light g_light8;
    layout(row_major) Light g_light9;
    layout(row_major) Light g_light10;
    layout(row_major) Light g_light11;
    layout(row_major) Light g_light12;
    layout(row_major) Light g_light13;
    layout(row_major) Light g_light14;
    layout(row_major) Light g_light15;
    layout(row_major) Light g_light16;
    layout(row_major) Light g_light17;
    layout(row_major) Light g_light18;
    layout(row_major) Light g_light19;
    layout(row_major) Light g_light20;
    layout(row_major) Light g_light21;
    layout(row_major) Light g_light22;
    layout(row_major) Light g_light23;
    layout(row_major) Light g_light24;
    layout(row_major) Light g_light25;
    layout(row_major) Light g_light26;
    layout(row_major) Light g_light27;
    layout(row_major) Light g_light28;
    layout(row_major) Light g_light29;
    layout(row_major) Light g_light30;
    layout(row_major) Light g_light31;
    layout(row_major) Light g_light32;
    layout(row_major) Light g_light33;
    layout(row_major) Light g_light34;
    layout(row_major) Light g_light35;
    layout(row_major) Light g_light36;
    layout(row_major) Light g_light37;
    layout(row_major) Light g_light38;
    layout(row_major) Light g_light39;
    layout(row_major) Light g_light40;
    layout(row_major) Light g_light41;
    layout(row_major) Light g_light42;
    layout(row_major) Light g_light43;
    layout(row_major) Light g_light44;
    layout(row_major) Light g_light45;
    layout(row_major) Light g_light46;
    layout(row_major) Light g_light47;
    layout(row_major) Light g_light48;
    layout(row_major) Light g_light49;
    layout(row_major) Light g_light50;
    layout(row_major) Light g_light51;
    layout(row_major) Light g_light52;
    layout(row_major) Light g_light53;
    layout(row_major) Light g_light54;
    layout(row_major) Light g_light55;
    layout(row_major) Light g_light56;
    layout(row_major) Light g_light57;
    layout(row_major) Light g_light58;
    layout(row_major) Light g_light59;
    layout(row_major) Light g_light60;
    layout(row_major) Light g_light61;
    layout(row_major) Light g_light62;
    layout(row_major) Light g_light63;
    layout(row_major) Light g_light64;
    layout(row_major) Light g_light65;
    layout(row_major) Light g_light66;
    layout(row_major) Light g_light67;
    layout(row_major) Light g_light68;
    layout(row_major) Light g_light69;
    layout(row_major) Light g_light70;
    layout(row_major) Light g_light71;
    layout(row_major) Light g_light72;
    layout(row_major) Light g_light73;
    layout(row_major) Light g_light74;
    layout(row_major) Light g_light75;
    layout(row_major) Light g_light76;
    layout(row_major) Light g_light77;
    layout(row_major) Light g_light78;
    layout(row_major) Light g_light79;
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
layout(location = 2) in vec4 in_var_TANGENT;
layout(location = 3) in vec2 in_var_TEXCOORD;
layout(location = 0) out vec3 out_var_TEXCOORD0;
layout(location = 1) out vec3 out_var_TEXCOORD1;
layout(location = 2) out vec3 out_var_TEXCOORD2;
layout(location = 3) out vec3 out_var_TEXCOORD3;
layout(location = 4) out vec2 out_var_TEXCOORD4;

VsOut src_main(VsIn vsIn)
{
    vec3 Pw = vec4(vsIn.Pobj, 1.0) * cbPerObject.g_WorldXf;
    VsOut vsOut;
    vsOut.Pclip = vec4(Pw, 1.0) * cbPerFrame.g_VpXf;
    vsOut.Pw = Pw;
    vsOut.Nw = normalize(vec4(vsIn.Nobj, 0.0) * cbPerObject.g_WorldXf);
    vsOut.Tw = normalize(vec4(vsIn.Tobj.xyz, 0.0) * cbPerObject.g_WorldXf);
    vsOut.Bw = cross(vsOut.Nw, vsOut.Tw) * vsIn.Tobj.w;
    vsOut.uv0 = vsIn.uv0;
    return vsOut;
}

void main()
{
    VsIn param_var_vsIn = VsIn(in_var_POSITION, in_var_NORMAL, in_var_TANGENT, in_var_TEXCOORD);
    VsOut _53 = src_main(param_var_vsIn);
    gl_Position = _53.Pclip;
    out_var_TEXCOORD0 = _53.Pw;
    out_var_TEXCOORD1 = _53.Nw;
    out_var_TEXCOORD2 = _53.Tw;
    out_var_TEXCOORD3 = _53.Bw;
    out_var_TEXCOORD4 = _53.uv0;
}

