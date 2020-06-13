
Shader "ShaderMan/OldPlasma"
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
	
    // normalized pixel coordinates
    fixed2 p = 6.0*i.uv/1;
	
    // pattern
    fixed f = sin(p.x + sin(2.0*p.y + _Time.y)) +
              sin(length(p)+_Time.y) +
              0.5*sin(p.x*2.5+_Time.y);
    
    // color
    fixed3 col = 0.7 + 0.3*cos(f+fixed3(0,2.1,4.2));

    // putput to screen
    return fixed4(col,1.0);

	}
	ENDCG
	}
  }
}

