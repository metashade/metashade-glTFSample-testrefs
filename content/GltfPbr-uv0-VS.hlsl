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

