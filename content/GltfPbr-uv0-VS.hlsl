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
	Light g_lights[80];
	int g_nLights;
	float g_lodBias;
};

cbuffer cbPerObject : register(b1)
{
	float3x4 g_WorldXf;
	float3x4 g_prevWorldXf;
};

struct VsIn
{
	float3 Pobj : POSITION;
	float3 Nobj : NORMAL;
	float2 uv0 : TEXCOORD;
};

struct VsOut
{
	float4 Pclip : SV_POSITION;
	float3 Pw : TEXCOORD0;
	float3 Nw : TEXCOORD1;
	float2 uv0 : TEXCOORD2;
};

VsOut main(VsIn vsIn)
{
	float3 Pw = mul(g_WorldXf, float4(vsIn.Pobj, 1.0));
	VsOut vsOut;
	vsOut.Pclip = mul(g_VpXf, float4(Pw, 1.0));
	vsOut.Pw = Pw.xyz;
	vsOut.Nw = normalize(mul(g_WorldXf, float4(vsIn.Nobj, 0.0)).xyz);
	vsOut.uv0 = vsIn.uv0;
	return vsOut;
}

