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

struct PbrFactors
{
    vec4 rgbaEmissive;
    vec4 rgbaBaseColor;
    float fMetallic;
    float fRoughness;
    vec2 f2Padding;
    vec4 rgbaDiffuse;
    vec3 rgbSpecular;
    float fGlossiness;
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

struct PsOut
{
    vec4 rgbaColor;
};

struct PbrParams
{
    vec3 rgbDiffuse;
    vec3 rgbF0;
    float fPerceptualRoughness;
    float fOpacity;
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
    PbrFactors g_perObjectPbrFactors;
} cbPerObject;

layout(set = 0, binding = 0) uniform texture2D g_tBaseColor;
layout(set = 0, binding = 0) uniform sampler g_sBaseColor;
layout(set = 0, binding = 1) uniform texture2D g_tEmissive;
layout(set = 0, binding = 1) uniform sampler g_sEmissive;
layout(set = 0, binding = 2) uniform texture2D g_tMetallicRoughness;
layout(set = 0, binding = 2) uniform sampler g_sMetallicRoughness;
layout(set = 0, binding = 3) uniform texture2D g_tNormal;
layout(set = 0, binding = 3) uniform sampler g_sNormal;
layout(set = 0, binding = 4) uniform texture2D g_tOcclusion;
layout(set = 0, binding = 4) uniform sampler g_sOcclusion;
layout(set = 0, binding = 5) uniform texture2D g_tIblBrdfLut;
layout(set = 0, binding = 5) uniform sampler g_sIblBrdfLut;
layout(set = 0, binding = 6) uniform textureCube g_tIblDiffuse;
layout(set = 0, binding = 6) uniform sampler g_sIblDiffuse;
layout(set = 0, binding = 7) uniform textureCube g_tIblSpecular;
layout(set = 0, binding = 7) uniform sampler g_sIblSpecular;
layout(set = 0, binding = 9) uniform texture2D g_tShadowMap;
layout(set = 0, binding = 9) uniform samplerShadow g_sShadowMap;

layout(location = 0) in vec3 in_var_TEXCOORD0;
layout(location = 1) in vec3 in_var_TEXCOORD1;
layout(location = 2) in vec3 in_var_TEXCOORD2;
layout(location = 3) in vec3 in_var_TEXCOORD3;
layout(location = 4) in vec2 in_var_TEXCOORD4;
layout(location = 0) out vec4 out_var_SV_TARGET;

vec3 getNormal(VsOut psIn)
{
    vec3 Nw = normalize(psIn.Nw);
    vec4 normalSample = texture(sampler2D(g_tNormal, g_sNormal), psIn.uv0, cbPerFrame.g_lodBias);
    mat3 tbn = mat3(normalize(psIn.Tw), normalize(psIn.Bw), Nw);
    Nw = normalize(((normalSample.xyz * 2.0) - vec3(1.0)) * transpose(tbn));
    return Nw;
}

PbrParams metallicRoughness(VsOut psIn)
{
    vec4 rgbaBaseColor = texture(sampler2D(g_tBaseColor, g_sBaseColor), psIn.uv0, cbPerFrame.g_lodBias);
    rgbaBaseColor *= cbPerObject.g_perObjectPbrFactors.rgbaBaseColor;
    float fAlphaCutoff = 0.87000000476837158203125;
    if ((rgbaBaseColor.w - fAlphaCutoff) < 0.0)
    {
        discard;
    }
    float fPerceptualRoughness = cbPerObject.g_perObjectPbrFactors.fRoughness;
    float fMetallic = cbPerObject.g_perObjectPbrFactors.fMetallic;
    vec4 metallicRoughnessSample = texture(sampler2D(g_tMetallicRoughness, g_sMetallicRoughness), psIn.uv0, cbPerFrame.g_lodBias);
    fPerceptualRoughness *= metallicRoughnessSample.y;
    fMetallic *= metallicRoughnessSample.z;
    fMetallic = clamp(fMetallic, 0.0, 1.0);
    float fMinF0 = 0.039999999105930328369140625;
    PbrParams pbrParams;
    pbrParams.rgbDiffuse = (rgbaBaseColor.xyz * (1.0 - fMinF0)) * (1.0 - fMetallic);
    pbrParams.rgbF0 = mix(vec3(fMinF0), rgbaBaseColor.xyz, vec3(fMetallic));
    pbrParams.fPerceptualRoughness = clamp(fPerceptualRoughness, 0.0, 1.0);
    pbrParams.fOpacity = rgbaBaseColor.w;
    return pbrParams;
}

float getRangeAttenuation(Light light, float d)
{
    return clamp(mix(1.0, 0.0, d / light.fRange), 0.0, 1.0);
}

float getPcfShadow(vec2 uv, float fCompareValue)
{
    float fResult = 0.0;
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(-2));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(-2, -1));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(-2, 0));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(-2, 1));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(-2, 2));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(-1, -2));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(-1));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(-1, 0));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(-1, 1));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(-1, 2));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(0, -2));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(0, -1));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(0));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(0, 1));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(0, 2));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(1, -2));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(1, -1));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(1, 0));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(1));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(1, 2));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(2, -2));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(2, -1));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(2, 0));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(2, 1));
    fResult += textureLodOffset(sampler2DShadow(g_tShadowMap, g_sShadowMap), vec3(uv, fCompareValue), 0.0, ivec2(2));
    fResult /= 25.0;
    return fResult;
}

float getSpotShadow(Light light, vec3 Pw)
{
    vec4 p4Shadow = vec4(Pw, 1.0) * light.VpXf;
    vec3 _550 = p4Shadow.xyz / vec3(p4Shadow.w);
    p4Shadow = vec4(_550.x, _550.y, _550.z, p4Shadow.w);
    vec2 uvShadow = (vec2(1.0) + vec2(p4Shadow.x, -p4Shadow.y)) * 0.5;
    float fCompareValue = p4Shadow.z - light.fDepthBias;
    vec2 param_var_uv = uvShadow;
    float param_var_fCompareValue = fCompareValue;
    float fShadow = getPcfShadow(param_var_uv, param_var_fCompareValue);
    return fShadow;
}

float D_Ggx(float NdotH, float fAlphaRoughness)
{
    float fASqr = fAlphaRoughness * fAlphaRoughness;
    float fF = (((NdotH * fASqr) - NdotH) * NdotH) + 1.0;
    return clamp(fASqr / ((3.1415927410125732421875 * fF) * fF), 0.0, 1.0);
}

vec3 F_Schlick(float LdotH, vec3 rgbF0)
{
    return rgbF0 + ((vec3(1.0) - rgbF0) * pow(1.0 - LdotH, 5.0));
}

float V_SmithGgxCorrelated(float NdotV, float NdotL, float fAlphaRoughness)
{
    float fASqr = fAlphaRoughness * fAlphaRoughness;
    float fGgxL = NdotV * sqrt(((NdotL - (NdotL * fASqr)) * NdotL) + fASqr);
    float fGgxV = NdotL * sqrt(((NdotV - (NdotV * fASqr)) * NdotV) + fASqr);
    float fV = 0.5 / (fGgxL + fGgxV);
    return clamp(fV, 0.0, 1.0);
}

float Fd_Lambert()
{
    return 0.3183098733425140380859375;
}

vec3 pbrBrdf(vec3 L, vec3 N, vec3 V, PbrParams pbrParams)
{
    float NdotV = abs(dot(N, V));
    float NdotL = clamp(dot(N, L), 0.0, 1.0);
    vec3 H = normalize(V + L);
    float NdotH = clamp(dot(N, H), 0.0, 1.0);
    float LdotH = clamp(dot(L, H), 0.0, 1.0);
    float fAlphaRoughness = pbrParams.fPerceptualRoughness * pbrParams.fPerceptualRoughness;
    float param_var_NdotH = NdotH;
    float param_var_fAlphaRoughness = fAlphaRoughness;
    float fD = D_Ggx(param_var_NdotH, param_var_fAlphaRoughness);
    float param_var_LdotH = LdotH;
    vec3 param_var_rgbF0 = pbrParams.rgbF0;
    vec3 rgbF = F_Schlick(param_var_LdotH, param_var_rgbF0);
    float param_var_NdotV = NdotV;
    float param_var_NdotL = NdotL;
    float param_var_fAlphaRoughness_1 = fAlphaRoughness;
    float fV = V_SmithGgxCorrelated(param_var_NdotV, param_var_NdotL, param_var_fAlphaRoughness_1);
    vec3 rgbFr = rgbF * (fD * fV);
    vec3 rgbFd = pbrParams.rgbDiffuse * Fd_Lambert();
    return (rgbFr + rgbFd) * NdotL;
}

vec3 applySpotLight(Light light, vec3 Nw, vec3 Vw, vec3 Pw, PbrParams pbrParams)
{
    vec3 Lw = light.Pw - Pw;
    Light param_var_light = light;
    float param_var_d = length(Lw);
    float fRangeAttenuation = getRangeAttenuation(param_var_light, param_var_d);
    Lw = normalize(Lw);
    float DdotL = dot(light.v3DirectionW, Lw);
    float fSpotAttenuation = smoothstep(light.fOuterConeCos, light.fInnerConeCos, DdotL);
    float fLightAttenuation = fRangeAttenuation * fSpotAttenuation;
    vec3 rgbLightColor = light.rgbColor * light.fIntensity;
    Light param_var_light_1 = light;
    vec3 param_var_Pw = Pw;
    float fShadow = getSpotShadow(param_var_light_1, param_var_Pw);
    vec3 param_var_L = Lw;
    vec3 param_var_N = Nw;
    vec3 param_var_V = Vw;
    PbrParams param_var_pbrParams = pbrParams;
    return ((pbrBrdf(param_var_L, param_var_N, param_var_V, param_var_pbrParams) * fLightAttenuation) * rgbLightColor) * fShadow;
}

vec3 getIbl(PbrParams pbrParams, vec3 N, vec3 V)
{
    float NdotV = clamp(dot(N, V), 0.0, 1.0);
    float fNumMips = 9.0;
    float fLod = pbrParams.fPerceptualRoughness * fNumMips;
    vec3 R = normalize(reflect(-V, N));
    vec2 f2BrdfSamplePoint = clamp(vec2(NdotV, pbrParams.fPerceptualRoughness), vec2(0.0), vec2(1.0));
    vec2 f2Brdf = texture(sampler2D(g_tIblBrdfLut, g_sIblBrdfLut), f2BrdfSamplePoint).xy;
    vec3 rgbDiffuseLight = texture(samplerCube(g_tIblDiffuse, g_sIblDiffuse), N).xyz;
    vec3 rgbSpecularLight = textureLod(samplerCube(g_tIblSpecular, g_sIblSpecular), R, fLod).xyz;
    vec3 rgbDiffuse = rgbDiffuseLight * pbrParams.rgbDiffuse;
    vec3 rgbSpecular = rgbSpecularLight * ((pbrParams.rgbF0 * f2Brdf.x) + vec3(f2Brdf.y));
    return rgbDiffuse + rgbSpecular;
}

PsOut src_main(VsOut psIn)
{
    vec3 Vw = normalize(cbPerFrame.g_cameraPw - psIn.Pw);
    VsOut param_var_psIn = psIn;
    vec3 Nw = getNormal(param_var_psIn);
    VsOut param_var_psIn_1 = psIn;
    PbrParams _164 = metallicRoughness(param_var_psIn_1);
    PbrParams pbrParams = _164;
    PsOut psOut;
    psOut.rgbaColor.w = pbrParams.fOpacity;
    Light param_var_light = Light(cbPerFrame.g_light0.VpXf, cbPerFrame.g_light0.ViewXf, cbPerFrame.g_light0.v3DirectionW, cbPerFrame.g_light0.fRange, cbPerFrame.g_light0.rgbColor, cbPerFrame.g_light0.fIntensity, cbPerFrame.g_light0.Pw, cbPerFrame.g_light0.fInnerConeCos, cbPerFrame.g_light0.fOuterConeCos, cbPerFrame.g_light0.type_, cbPerFrame.g_light0.fDepthBias, cbPerFrame.g_light0.iShadowMap);
    vec3 param_var_Nw = Nw;
    vec3 param_var_Vw = Vw;
    vec3 param_var_Pw = psIn.Pw;
    PbrParams param_var_pbrParams = pbrParams;
    vec3 _193 = applySpotLight(param_var_light, param_var_Nw, param_var_Vw, param_var_Pw, param_var_pbrParams);
    psOut.rgbaColor = vec4(_193.x, _193.y, _193.z, psOut.rgbaColor.w);
    PbrParams param_var_pbrParams_1 = pbrParams;
    vec3 param_var_N = Nw;
    vec3 param_var_V = Vw;
    vec3 _210 = psOut.rgbaColor.xyz + (getIbl(param_var_pbrParams_1, param_var_N, param_var_V) * cbPerFrame.g_fIblFactor);
    psOut.rgbaColor = vec4(_210.x, _210.y, _210.z, psOut.rgbaColor.w);
    vec4 occlusionSample = texture(sampler2D(g_tOcclusion, g_sOcclusion), psIn.uv0, cbPerFrame.g_lodBias);
    vec3 _229 = psOut.rgbaColor.xyz * occlusionSample.x;
    psOut.rgbaColor = vec4(_229.x, _229.y, _229.z, psOut.rgbaColor.w);
    vec3 rgbEmissive = cbPerObject.g_perObjectPbrFactors.rgbaEmissive.xyz * cbPerFrame.g_fPerFrameEmissiveFactor;
    vec4 emissiveSample = texture(sampler2D(g_tEmissive, g_sEmissive), psIn.uv0, cbPerFrame.g_lodBias);
    rgbEmissive *= emissiveSample.xyz;
    vec3 _258 = psOut.rgbaColor.xyz + rgbEmissive;
    psOut.rgbaColor = vec4(_258.x, _258.y, _258.z, psOut.rgbaColor.w);
    return psOut;
}

void main()
{
    VsOut param_var_psIn = VsOut(gl_FragCoord, in_var_TEXCOORD0, in_var_TEXCOORD1, in_var_TEXCOORD2, in_var_TEXCOORD3, in_var_TEXCOORD4);
    PsOut _123 = src_main(param_var_psIn);
    out_var_SV_TARGET = _123.rgbaColor;
}

