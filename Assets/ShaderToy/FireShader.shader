//FROM https://www.shadertoy.com/view/3slcRM
Shader "ShaderMan/FireShader"
	{

	Properties{
	_MainTex ("MainTex", 2D) = "white" {}
	_SecondTex("SecondTex", 2D) = "white" {}
		_Speed("Speed", Range(-10,10)) =3
		_Size("Size", Range(0,10)) = 3
		_Amplitude("Amplitude", Range(0,10.00)) = 1
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
sampler2D _SecondTex;
sampler2D _MainTex;

float _Amplitude;
float _Speed;
float _Size;



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
	
    fixed off_y = -_Time.y/ _Speed;
    
    // sample
    fixed2 uv = i.uv;
    fixed v = tex2D(_MainTex,fixed2(uv.x* _Amplitude,uv.y+off_y)).r/(i.uv.y/ _Size)*tex2D(_SecondTex,fixed2(uv.x,uv.y+off_y)).r;
    
    fixed3 col = fixed3(0.0,0.0,0.0);
    col.r = pow(v,8.0);
    col.g = pow(v,2.0)*0.1;
    col.b = col.g*0.2;

    // output
    return fixed4(clamp(col,0.0,1.0), col.r + col.g +col.b);
	
	}
	ENDCG
	}
  }
}

