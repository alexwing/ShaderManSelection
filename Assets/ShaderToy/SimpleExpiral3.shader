
Shader "ShaderMan/SimpleExpiral"
	{

	Properties{
		//_MainTex("Albedo Texture", 2D) = "white" {}

		_Size("Size", Range(0.0,3)) = 0.25
		_Spiral("Spiral", Range(0.0,30)) = 6.28

		_Velocity("Velocity", Range(0.0,30)) = 15.0
		_Intensity("Intensity", Range(0.0,30)) = 15.0



		_Transparency("Transparency", Range(0.0,1.0)) = 0.25
		_CutoutThresh("Cutout Threshold", Range(0.0,1.0)) = 0.2
		_CutoutThresh2("Cutout Threshold2", Range(0.0,1.0)) = 0.2

		_R("R", Range(0.0,1)) = 0.0
		_G("G", Range(0.0,1)) = 0.0
		_B("B", Range(0.0,1)) = 0.0

	}


	SubShader
	{
	Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

	Pass
	{
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha

	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"

	struct VertexInput {
    fixed4 vertex : POSITION;
	fixed2 uv:TEXCOORD0;
    fixed4 tangent : TANGENT;
    fixed3 normal : NORMAL;
	//VertexInput
	};


	struct VertexOutput {
	fixed4 pos : SV_POSITION;
	fixed2 uv:TEXCOORD0;
	//VertexOutput
	};

	//Variables

	

	float _Size;
	float _Spiral;
	float _Velocity;
	float _Intensity;

	float _Transparency;
	float _CutoutThresh;
	float _CutoutThresh2;

	float _R;
	float _G;
	float _B;

	sampler2D _MainTex;

	fixed4 noise(fixed4 x)
	{
		fixed4 p = floor(x);
		fixed4 f = frac(x);
		f = f * f*(3.0 - 2.0*f);
		fixed2 uv = (p.xy + fixed2(37.0, 17.0)*p.z) + f.xy;
		fixed2 rg = tex2D(_MainTex,  256.0, -100.0, 0.0).yx + uv;
		return lerp(rg.x, rg.y, f.z);
	}

	VertexOutput vert (VertexInput v)
	{
	VertexOutput o;
	o.pos = UnityObjectToClipPos (v.vertex);
	o.uv = v.uv;
	//VertexFactory
	return o;
	}
	fixed4 frag(VertexOutput i) : SV_Target
	{
	
	fixed2 uv = i.uv / 1;
    fixed ar = 1 / 1;
    fixed4 temp = fixed4(0.0,0.0,0.0,1.0);
    fixed2 center = fixed2(0.5,0.5);
    fixed2 fromCenter = uv - center;
    fixed angle = atan2( fromCenter.x, fromCenter.y);
    fromCenter.x *= ar;
    fixed fromCenterLength = length(fromCenter);
    
    temp.a = _Size + sin(angle*1.0 + fromCenterLength * _Spiral * _Intensity - _Time.y * _Velocity)* 0.5;
	temp.a -= fromCenterLength * 2.0;
	

	//temp.r -= noise(temp);
	//temp.g -= noise(temp);
	//temp.b -= noise(temp);
	temp.a = temp.a*-1.0;
	// sample the texture
	//temp.a = _Transparency;
	clip(temp.a + _CutoutThresh);
	clip(_Size + sin(angle*1.0 + fromCenterLength * _Spiral * _Intensity - _Time.y * _Velocity)* 0.5 - _CutoutThresh2);
	//temp.a -= _Transparency;

	temp.a = -sin(temp.a) + _CutoutThresh;
	if (temp.a < 0.0) {
		temp.a = 0.0;
	}
	temp.r = temp.a;
	temp.g = temp.a;
	temp.b = temp.a;
	temp.r += _R;
	temp.g += _G;
	temp.b += _B;
	//clip(temp.r - _CutoutThresh2);
	//temp.a = _Size / 0.40 + sin(angle*1.0 + fromCenterLength * 6.28 * 15.0 - _Time.y * 15.0)* 0.5;
    return temp;

	}


	ENDCG
	}
  }
}

