
Shader "ShaderMan/SimpleExpiral4"
	{

	Properties{
		_MainTex("Albedo Texture", 2D) = "white" {}

		_Size("Size", Range(0.0,3)) = 0.25
		_Spiral("Spiral", Range(0.0,30)) = 6.28

		_Velocity("Velocity", Range(0.0,30)) = 15.0
		_Intensity("Intensity", Range(0.0,30)) = 15.0

			
			


		_Transparency("Transparency", Range(0.0,1.0)) = 0.25
		_CutoutThresh("Cutout Threshold", Range(0.0,1.0)) = 0.2
		_CutoutThresh2("Cutout Threshold2", Range(0.0,1.0)) = 0.2

		_R("R", Range(0.0,1.0)) = 0.0
		_G("G", Range(0.0,1.0)) = 0.0
		_B("B", Range(0.0,1.0)) = 0.0

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

    temp.a = _Size + sin(angle + fromCenterLength * _Spiral * _Intensity - _Time.y * _Velocity)* 0.5;
	clip(temp.a + _CutoutThresh);
//	temp.a -= fromCenterLength * 2.0;
	//clip(temp.a - _CutoutThresh2);
	temp.r = temp.a;
	temp.g = temp.a;
	temp.b = temp.a;
	temp.r += _R;
	temp.g += _G;
	temp.b += _B;

	//temp.a = _Size + sin(angle*1.0 + fromCenterLength * 6.28 * _Intensity - _Time.y * _Velocity)* 0.5 ;	

	//temp.a = _Size+ sin(angle*1.0 + fromCenterLength * _Spiral * _Intensity - _Time.y * _Velocity)* -_CutoutThresh;
	temp.a = -sin(temp.a) + _CutoutThresh;
	if (temp.a < 0.0) {
		temp.a = 0.0;
	}
	// sample the texture
	//temp.a = _Transparency;
	//clip(temp.a - _CutoutThresh);
	//temp.a *= _Transparency;
	//clip(temp.r - _CutoutThresh2);
	//clip(temp.g - _CutoutThresh2);
	//clip(temp.b - _CutoutThresh2);



    return temp;

	}

	ENDCG
	}
  }
}

