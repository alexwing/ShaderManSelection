
Shader "ShaderMan/Flowofcells"
	{

	Properties{
	//Properties
		 FIELD("FIELD", Range(0.0, 40.0)) = 20.0
		  HEIGHT("HEIGHT", Range(0.0, 2)) = 0.7
		 ITERATION("ITERATION", Range(1, 10)) =2
		 
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

	// Created by sofiane benchaa - sben/2015
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
	
//#define FIELD 20.0
//#define HEIGHT 0.7
//#define ITERATION 2
#define TONE fixed3(0.5,0.2,0.3)
	float FIELD;
	float HEIGHT;
	int ITERATION;

fixed2 eq(fixed2 p,fixed t){
	fixed2 fx = fixed2(0.0,0.0);
	fx.x = (sin(p.y+cos(t+p.x*0.2))*cos(p.x-t));
	fx.x *= acos(fx.x);
	fx.x *= -distance(fx.x,0.5)*p.x/p.y;
	fx.y = p.y-fx.x;
	return fx;
}

fixed3 computeColor(fixed2 p, fixed t, fixed hs){
	fixed3 color = fixed3(0.0,0.0,0.0);
	fixed2 fx = eq(p,t);
	[unroll(100)]
for(int i=0; i<ITERATION; ++i)
	{
		p.x+=p.x;
		color.r += TONE.r/length(fx.y-fx.x-hs);
		fx.x += eq(p,t+fixed(i+1)).x;
		color.g += TONE.g/length(fx.y-fx.x-hs);
		fx.x += eq(p,t+fixed(i+2)).x;
		color.b += TONE.b/length(fx.y-fx.x-hs);
	}
	return color;
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
	fixed2 position = ( i.uv / 1 )+0.5;
	fixed hs = FIELD*(HEIGHT+cos(time)*0.1);
	fixed2 p = (position)*FIELD;
	fixed3 color = computeColor(p, time, hs);
	return fixed4( color, 1.0 );

	}
	ENDCG
	}
  }
}

