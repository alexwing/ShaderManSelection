
Shader "ShaderMan/Plasma"
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

	// digital's first plasma!

fixed3 palette(fixed pos, fixed time)
{
	return fixed3(sin(3.14/2.0*pos),cos(6.2*pos), cos(pos+time/10.0));
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
	
    fixed time = _Time.y;
	fixed2 p = i.uv / 1;
	// translate
	p.y += 0.1;
	// zoom to a good looking spot
	p *= 0.25;
	
	// start the plasma magic!
	fixed part1 = sin(p.x*(90.0+21.0*cos(p.y*0.0))+time);
	fixed part2 = cos(p.y*(32.0+11.0*sin(p.x*57.0))+time);
	fixed part3 = sin(p.x*(55.0 + 21.0*sin(p.y*32.0))+ time);
	fixed plas = 0.5 + 0.65*part1*part2 + 0.35*part3*part2;
	
	return fixed4(palette(plas, time),1.0);

	}
	ENDCG
	}
  }
}

