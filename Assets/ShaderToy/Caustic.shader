
Shader "ShaderMan/Caustic"
	{

	Properties{
	//Properties
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

	#define TAU 6.28318530718
#define MAX_ITER 5





	VertexOutput vert (VertexInput v)
	{
	VertexOutput o;
	o.pos = UnityObjectToClipPos (v.vertex);
	o.uv = v.uv;
	//VertexFactory
	return o;
	}
	fixed4 frag(VertexOutput i2) : SV_Target
	{

	fixed time = _Time.y * .5 + 23.0;
	// uv should be the 0-1 uv of tex2D...
	fixed2 uv = i2.uv / 1;


	fixed2 p = fmod(uv*TAU, TAU) - 250.0;

	fixed2 i = p;
	fixed c = 1.0;
	fixed inten = .005;

	for (int n = 0; n < MAX_ITER; n++)
	{
		fixed t = time * (1.0 - (3.5 / fixed(n + 1)));
		i = p + fixed2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
		c += 1.0 / length(fixed2(p.x / (sin(i.x + t) / inten),p.y / (cos(i.y + t) / inten)));

	}

	c /= float(MAX_ITER);
	c = 1.17 - pow(c, 1.4);
	fixed3 colour = fixed3(pow(abs(c), 8.0),1.0,1.0);
	colour = clamp(colour + fixed3(0.0, 0.35, 0.5), 0.0, 1.0);

	return fixed4(colour, 1.0);
	}
	ENDCG
	}
  }
}

