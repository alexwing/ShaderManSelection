
Shader "ShaderMan/Squares"
{

	Properties{
		//Properties
		_Color("Spec Color", Color) = (0,0,0,0)
		_Color2("Spec Color", Color) = (0,0,0,0)
		_Speed("Speed", Range(-10,10)) = 0.1
		_Size("Size",  Range(-10,10)) = 0.1
		_AmplitudeX("AmplitudeX", Range(0,10.00)) = 5
		_AmplitudeY("AmplitudeY", Range(0,10.00)) = 5
	
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


	struct VertexOutput {
	fixed4 pos : SV_POSITION;
	fixed2 uv : TEXCOORD0;
	//VertexOutput
	};

	//Variables


	fixed4 _Color;
	fixed4 _Color2;
	float _Speed;
	float _Size;
	float _AmplitudeX;
	float _AmplitudeY;

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

	fixed aspect = 1 / 1;
	fixed value;
	fixed2 uv = i.uv / 1;
	uv -= fixed2(0.5, 0.5 * aspect);
	fixed rot = radians(45.0); // radians(45.0*sin(_Time.y));
	fixed2 m = fixed2(cos(rot), -sin(rot));
	uv = m * uv;
	uv += fixed2(0.5, 0.5 * aspect);
	uv.y += 0.5 * (1.0 - aspect);
	fixed2 pos = 10.0 * uv;
	fixed2 rep = frac(pos);
	fixed dist = 2.0 * min(min(rep.x, 1.0 - rep.x), min(rep.y, 1.0 - rep.y));
	fixed squareDist = length((floor(pos) + fixed2(0.5,0.5)) - fixed2(_AmplitudeX, _AmplitudeY));

	fixed edge = sin(_Time.y - squareDist * 0.5) * 0.5 + 0.5;

	edge = (_Time.y - squareDist * _Size) * _Speed;
	edge = 2.0 * frac(edge * 0.5);
	//value = 2.0*abs(dist-0.5);
	//value = pow(dist, 2.0);
	value = frac(dist * 2.0);
	value = lerp(value, 1.0 - value, step(1.0, edge));
	//value *= 1.0-0.5*edge;
	edge = pow(abs(1.0 - edge), 2.0);

	//edge = abs(1.0-edge);
	value = smoothstep(edge - 0.05, edge, 0.95 * value);


	value += squareDist * .1;
	//return fixed3(value,value,value,value);
	return lerp(fixed4(_Color2.r, _Color2.g, _Color2.b,1.0),fixed4(_Color.r, _Color.g, _Color.b,1.0), value);
	///fragColor.a = 0.25*clamp(value, 0.0, 1.0);

	}
	ENDCG
	}
	}
}

