
Shader "ShaderMan/WaterRipples"
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

	
fixed height(in fixed2 uv){
    fixed speed = 6.0;

    fixed topright=		sin(_Time.y*(speed+1.0)	-sin(length(uv-fixed2(1.0,1.0)))*53.0);
    fixed topleft=		sin(_Time.y*(speed+1.0)	-sin(length(uv-fixed2(0.0,1.0)))*37.0);
    fixed bottomright=	sin(_Time.y*(speed)    	-sin(length(uv-fixed2(1.0,0.0)))*61.0);
    fixed bottomleft=	sin(_Time.y*(speed+2.0)	-sin(length(uv-fixed2(0.0,0.0)))*47.0);

    fixed horizontalWaves=sin(_Time.y*(speed+2.0)-sin(uv.y)*47.0);
    
    
    fixed temp = horizontalWaves +bottomleft*0.4 +bottomright*0.2 +topleft*0.6 +topright*0.3;
    
    fixed b=smoothstep(-2.5,5.0,temp);
    return b*3.0;
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
	
	fixed2 uv=i.uv/1;
    
    fixed waveHeight=0.4+height(uv);
    
    fixed3 color=fixed3(waveHeight*0.3,waveHeight*0.5,waveHeight);
    
    return fixed4( color, 1.0 );

	}
	ENDCG
	}
  }
}

