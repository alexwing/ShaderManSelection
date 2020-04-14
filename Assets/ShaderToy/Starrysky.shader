
Shader "ShaderMan/Starrysky "
{

	Properties{
		_Speed("Speed", Range(-100,100)) = 0.1
		_Scale("Scale", Range(-2,2)) = 0
		_Speed2("Speed2", Range(-100,100)) = 0.1
		_brightness("brightness", Range(-1,3)) = 0.5
		_Colour("Colour", Range(0,10)) = 0.5
		_Glow("Glow", Range(0,150)) = 50
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
	fixed2 uv : TEXCOORD0;
	fixed4 tangent : TANGENT;
	fixed3 normal : NORMAL;
	//VertexInput
	};
	float _Speed;
	float _Speed2;
	float _brightness;
	float _Colour;
	float _Glow;
	float _Scale;

	struct VertexOutput {
	fixed4 pos : SV_POSITION;
	fixed2 uv : TEXCOORD0;
	//VertexOutput
	};

	//Variables



	




	VertexOutput vert(VertexInput v)
	{
	VertexOutput o;
	o.pos = UnityObjectToClipPos(v.vertex);
	o.uv = v.uv;
	//VertexFactory
	return o;
	}
	fixed4 frag(VertexOutput i) : SV_Target
	{

	fixed2 uv = i.uv / 1 - .5;
	uv /= 1 / _Scale;

	//rotation
	fixed ta = 1., s = sin(ta), c = cos(ta);
	//fixed ta = _Time.y / 10., s = sin(ta), c = cos(ta);
	uv *= fixed4(c,s,-s,c);

	//FOV
	uv *= 4000.;

	fixed3 col = fixed3(0,0,0);
	[unroll(100)]
	for (fixed i = 0.; i < 125.; i++)
	{
		fixed3 pos = 700. * cos(i * fixed3(21.32,423.123,213.23)) - 30.; //star's coord

		pos.z = fmod(pos.z + _Speed2 * _Time.y,45.); //move stars

		fixed2 screenpos = _Speed * pos.xy / pos.z; //convert to 2d screen coordinates
		col += 8. * (1. - pos.z / _Glow) / (1. + length(uv - screenpos)) * (_Colour * sin(i * fixed3(7.12,9.42,4.11) + _Time.y) + _brightness); //color dots

	}

	return fixed4(col, 1.0);
	}
		ENDCG
	}
	}
}
