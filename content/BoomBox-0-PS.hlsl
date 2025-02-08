struct Light
{
	float4x4 VpXf;
	float4x4 ViewXf;
	float3 v3DirectionW;
	float fRange;
	float3 rgbColor;
	float fIntensity;
	float3 Pw;
	float fInnerConeCos;
	float fOuterConeCos;
	int type_;
	float fDepthBias;
	int iShadowMap;
};

cbuffer cbPerFrame : register(b0)
{
	float4x4 g_VpXf;
	float4x4 g_prevVpXf;
	float4x4 g_VpIXf;
	float3 g_cameraPw;
	float g_cameraPw_fPadding;
	float g_fIblFactor;
	float g_fPerFrameEmissiveFactor;
	float2 g_fInvScreenResolution;
	float4 g_f4WireframeOptions;
	float2 g_f2MCameraCurrJitter;
	float2 g_f2MCameraPrevJitter;
	Light g_light0;
	Light g_light1;
	Light g_light2;
	Light g_light3;
	Light g_light4;
	Light g_light5;
	Light g_light6;
	Light g_light7;
	Light g_light8;
	Light g_light9;
	Light g_light10;
	Light g_light11;
	Light g_light12;
	Light g_light13;
	Light g_light14;
	Light g_light15;
	Light g_light16;
	Light g_light17;
	Light g_light18;
	Light g_light19;
	Light g_light20;
	Light g_light21;
	Light g_light22;
	Light g_light23;
	Light g_light24;
	Light g_light25;
	Light g_light26;
	Light g_light27;
	Light g_light28;
	Light g_light29;
	Light g_light30;
	Light g_light31;
	Light g_light32;
	Light g_light33;
	Light g_light34;
	Light g_light35;
	Light g_light36;
	Light g_light37;
	Light g_light38;
	Light g_light39;
	Light g_light40;
	Light g_light41;
	Light g_light42;
	Light g_light43;
	Light g_light44;
	Light g_light45;
	Light g_light46;
	Light g_light47;
	Light g_light48;
	Light g_light49;
	Light g_light50;
	Light g_light51;
	Light g_light52;
	Light g_light53;
	Light g_light54;
	Light g_light55;
	Light g_light56;
	Light g_light57;
	Light g_light58;
	Light g_light59;
	Light g_light60;
	Light g_light61;
	Light g_light62;
	Light g_light63;
	Light g_light64;
	Light g_light65;
	Light g_light66;
	Light g_light67;
	Light g_light68;
	Light g_light69;
	Light g_light70;
	Light g_light71;
	Light g_light72;
	Light g_light73;
	Light g_light74;
	Light g_light75;
	Light g_light76;
	Light g_light77;
	Light g_light78;
	Light g_light79;
	int g_nLights;
	float g_lodBias;
};

struct PbrFactors
{
	float4 rgbaEmissive;
	float4 rgbaBaseColor;
	float fMetallic;
	float fRoughness;
	float2 f2Padding;
	float4 rgbaDiffuse;
	float3 rgbSpecular;
	float fGlossiness;
};

cbuffer cbPerObject : register(b1)
{
	float3x4 g_WorldXf;
	float3x4 g_prevWorldXf;
	PbrFactors g_perObjectPbrFactors;
};

struct VsOut
{
	float4 Pclip : SV_POSITION;
	float3 Pw : TEXCOORD0;
	float3 Nw : TEXCOORD1;
	float3 Tw : TEXCOORD2;
	float3 Bw : TEXCOORD3;
	float2 uv0 : TEXCOORD4;
};

struct PsOut
{
	float4 rgbaColor : SV_TARGET;
};

struct PbrParams
{
	float3 rgbDiffuse;
	float3 rgbF0;
	float fPerceptualRoughness;
	float fOpacity;
};

// https://google.github.io/filament/Filament.md.html#materialsystem/specularbrdf/normaldistributionfunction(speculard)
// 
float D_Ggx(float NdotH, float fAlphaRoughness)
{
	float fASqr = (fAlphaRoughness * fAlphaRoughness);
	float fF = ((((NdotH * fASqr) - NdotH) * NdotH) + 1.0);
	return saturate((fASqr / ((3.141592653589793 * fF) * fF)));
}

float3 F_Schlick(float LdotH, float3 rgbF0)
{
	return (rgbF0 + ((1.0.xxx - rgbF0) * pow((1.0 - LdotH), 5.0)));
}

// https://google.github.io/filament/Filament.md.html#materialsystem/specularbrdf/geometricshadowing(specularg)
// 
float V_SmithGgxCorrelated(float NdotV, float NdotL, float fAlphaRoughness)
{
	float fASqr = (fAlphaRoughness * fAlphaRoughness);
	float fGgxL = (NdotV * sqrt((((NdotL - (NdotL * fASqr)) * NdotL) + fASqr)));
	float fGgxV = (NdotL * sqrt((((NdotV - (NdotV * fASqr)) * NdotV) + fASqr)));
	float fV = (0.5 / (fGgxL + fGgxV));
	return saturate(fV);
}

float Fd_Lambert()
{
	return 0.3183098861837907;
}

float3 pbrBrdf(float3 L, float3 N, float3 V, PbrParams pbrParams)
{
	float NdotV = abs(dot(N, V));
	float NdotL = saturate(dot(N, L));
	float3 H = normalize((V + L));
	float NdotH = saturate(dot(N, H));
	float LdotH = saturate(dot(L, H));
	float fAlphaRoughness = (pbrParams.fPerceptualRoughness * pbrParams.fPerceptualRoughness);
	float fD = D_Ggx(NdotH, fAlphaRoughness);
	float3 rgbF = F_Schlick(LdotH, pbrParams.rgbF0);
	float fV = V_SmithGgxCorrelated(NdotV, NdotL, fAlphaRoughness);
	float3 rgbFr = ((fD * fV) * rgbF);
	float3 rgbFd = (pbrParams.rgbDiffuse * Fd_Lambert());
	return (NdotL * (rgbFr + rgbFd));
}

float getRangeAttenuation(Light light, float d)
{
	return saturate(lerp(1, 0, (d / light.fRange)));
}

Texture2D g_tBaseColor : register(t0);
SamplerState g_sBaseColor : register(s0);
Texture2D g_tEmissive : register(t1);
SamplerState g_sEmissive : register(s1);
Texture2D g_tMetallicRoughness : register(t2);
SamplerState g_sMetallicRoughness : register(s2);
Texture2D g_tNormal : register(t3);
SamplerState g_sNormal : register(s3);
Texture2D g_tOcclusion : register(t4);
SamplerState g_sOcclusion : register(s4);
Texture2D g_tIblBrdfLut : register(t5);
SamplerState g_sIblBrdfLut : register(s5);
TextureCube g_tIblDiffuse : register(t6);
SamplerState g_sIblDiffuse : register(s6);
TextureCube g_tIblSpecular : register(t7);
SamplerState g_sIblSpecular : register(s7);
Texture2D g_tShadowMap : register(t9);
SamplerComparisonState g_sShadowMap : register(s9);
PbrParams metallicRoughness(VsOut psIn)
{
	float4 rgbaBaseColor = g_tBaseColor.SampleBias(g_sBaseColor, psIn.uv0, g_lodBias);
	rgbaBaseColor = (rgbaBaseColor * g_perObjectPbrFactors.rgbaBaseColor);
	float fPerceptualRoughness = g_perObjectPbrFactors.fRoughness;
	float fMetallic = g_perObjectPbrFactors.fMetallic;
	float4 metallicRoughnessSample = g_tMetallicRoughness.SampleBias(g_sMetallicRoughness, psIn.uv0, g_lodBias);
	fPerceptualRoughness = (fPerceptualRoughness * metallicRoughnessSample.g);
	fMetallic = (fMetallic * metallicRoughnessSample.b);
	fMetallic = saturate(fMetallic);
	float fMinF0 = 0.04;
	PbrParams pbrParams;
	pbrParams.rgbDiffuse = ((rgbaBaseColor.rgb * (1.0 - fMinF0)) * (1.0 - fMetallic));
	pbrParams.rgbF0 = lerp(fMinF0.xxx, rgbaBaseColor.rgb, fMetallic.xxx);
	pbrParams.fPerceptualRoughness = saturate(fPerceptualRoughness);
	pbrParams.fOpacity = rgbaBaseColor.a;
	return pbrParams;
}

float getPcfShadow(float2 uv, float fCompareValue)
{
	float fResult = 0;
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(-2, -2)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(-2, -1)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(-2, 0)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(-2, 1)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(-2, 2)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(-1, -2)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(-1, -1)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(-1, 0)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(-1, 1)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(-1, 2)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(0, -2)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(0, -1)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(0, 0)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(0, 1)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(0, 2)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(1, -2)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(1, -1)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(1, 0)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(1, 1)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(1, 2)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(2, -2)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(2, -1)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(2, 0)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(2, 1)).r);
	fResult = (fResult + g_tShadowMap.SampleCmpLevelZero(g_sShadowMap, uv, fCompareValue, int2(2, 2)).r);
	fResult = (fResult / 25);
	return fResult;
}

float getSpotShadow(Light light, float3 Pw)
{
	float4 p4Shadow = mul(light.VpXf, float4(Pw, 1.0));
	p4Shadow.xyz = (p4Shadow.xyz / p4Shadow.w);
	float2 uvShadow = ((1.0.xx + float2(p4Shadow.x, -p4Shadow.y)) * 0.5);
	float fCompareValue = (p4Shadow.z - light.fDepthBias);
	float fShadow = getPcfShadow(uvShadow, fCompareValue);
	return fShadow;
}

float3 applySpotLight(Light light, float3 Nw, float3 Vw, float3 Pw, PbrParams pbrParams)
{
	float3 Lw = (light.Pw - Pw);
	float fRangeAttenuation = getRangeAttenuation(light, length(Lw));
	Lw = normalize(Lw);
	float DdotL = dot(light.v3DirectionW, Lw);
	float fSpotAttenuation = smoothstep(light.fOuterConeCos, light.fInnerConeCos, DdotL);
	float fLightAttenuation = (fRangeAttenuation * fSpotAttenuation);
	float3 rgbLightColor = (light.fIntensity * light.rgbColor);
	float fShadow = getSpotShadow(light, Pw);
	return (((pbrBrdf(Lw, Nw, Vw, pbrParams) * fLightAttenuation) * rgbLightColor) * fShadow);
}

float3 getIbl(PbrParams pbrParams, float3 N, float3 V)
{
	float NdotV = saturate(dot(N, V));
	float fNumMips = 9;
	float fLod = (pbrParams.fPerceptualRoughness * fNumMips);
	float3 R = normalize(reflect(-V, N));
	float2 f2BrdfSamplePoint = saturate(float2(NdotV, pbrParams.fPerceptualRoughness));
	float2 f2Brdf = g_tIblBrdfLut.Sample(g_sIblBrdfLut, f2BrdfSamplePoint).xy;
	float3 rgbDiffuseLight = g_tIblDiffuse.Sample(g_sIblDiffuse, N).rgb;
	float3 rgbSpecularLight = g_tIblSpecular.SampleLevel(g_sIblSpecular, R, fLod).rgb;
	float3 rgbDiffuse = (rgbDiffuseLight * pbrParams.rgbDiffuse);
	float3 rgbSpecular = (rgbSpecularLight * ((pbrParams.rgbF0 * f2Brdf.x) + f2Brdf.y.xxx));
	return (rgbDiffuse + rgbSpecular);
}

float3 getNormal(VsOut psIn)
{
	float3 Nw = normalize(psIn.Nw);
	float4 normalSample = g_tNormal.SampleBias(g_sNormal, psIn.uv0, g_lodBias);
	float3x3 tbn = float3x3(normalize(psIn.Tw), normalize(psIn.Bw), Nw);
	Nw = normalize(mul(transpose(tbn), ((2.0 * normalSample.xyz) - 1.0.xxx)));
	return Nw;
}

PsOut main(VsOut psIn)
{
	float3 Vw = normalize((g_cameraPw - psIn.Pw));
	float3 Nw = getNormal(psIn);
	PbrParams pbrParams = metallicRoughness(psIn);
	PsOut psOut;
	psOut.rgbaColor.a = pbrParams.fOpacity;
	psOut.rgbaColor.rgb = applySpotLight(g_light0, Nw, Vw, psIn.Pw, pbrParams);
	psOut.rgbaColor.rgb = (psOut.rgbaColor.rgb + (getIbl(pbrParams, Nw, Vw) * g_fIblFactor));
	float4 occlusionSample = g_tOcclusion.SampleBias(g_sOcclusion, psIn.uv0, g_lodBias);
	psOut.rgbaColor.rgb = (psOut.rgbaColor.rgb * occlusionSample.x);
	float3 rgbEmissive = (g_perObjectPbrFactors.rgbaEmissive.rgb * g_fPerFrameEmissiveFactor);
	float4 emissiveSample = g_tEmissive.SampleBias(g_sEmissive, psIn.uv0, g_lodBias);
	rgbEmissive = (rgbEmissive * emissiveSample.rgb);
	psOut.rgbaColor.rgb = (psOut.rgbaColor.rgb + rgbEmissive);
	return psOut;
}

