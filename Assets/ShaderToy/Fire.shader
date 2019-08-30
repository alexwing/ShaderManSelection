
Shader "ShaderMan/Fire"
{

	Properties{
			_Size("Size", Range(0.0,3)) = 0.25
			_Velocity("Velocity", Range(-10,10)) = 0.0
			_blur("Blur", Range(-10,10)) = 0.0
			_Distortion("Distortion", Range(-1,1)) = 0.0
			_Noise("Noise", Range(0.0,1.0)) = 0.2
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


	float _Size;
	float _Velocity;
	float _Distortion;
	float _Noise;
	float _blur;
	fixed snoise(fixed3 uv, fixed res)
	{
		const fixed3 s = fixed3(1e0, 1e2, 1e3);

		uv *= res;

		fixed3 uv0 = floor(fmod(uv, res))*s;
		fixed3 uv1 = floor(fmod(uv + fixed3(1.,1.,1.), res))*s;

		fixed3 f = frac(uv); f = f * f*(3.0 - 2.0*f);

		fixed4 v = fixed4(uv0.x + uv0.y + uv0.z, uv1.x + uv0.y + uv0.z,
					  uv0.x + uv1.y + uv0.z, uv1.x + uv1.y + uv0.z);

		fixed4 r = frac(sin(v*1e-1)*1e3);
		fixed r0 = lerp(lerp(r.x, r.y, f.x), lerp(r.z, r.w, f.x), f.y);

		r = frac(sin((v + uv1.z - uv0.z)*1e-1)*1e3);
		fixed r1 = lerp(lerp(r.x, r.y, f.x), lerp(r.z, r.w, f.x), f.y);

		return lerp(r0, r1, f.z)*2. - 1.;
	}



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

		fixed2 p = -.5 + i.uv / 1;
		p.x *= 1 / 1;

		fixed color = _Size - (3.*length(2.*p));

		fixed3 coord = fixed3(atan2(p.y,p.x) / 6.2832 + 1.5, length(p)*_Distortion, .5);

		[unroll(100)]
		for (int i = 1; i <= 7; i++)
		{
			fixed power = pow(2.0, fixed(i));
			color += (1.5 / power * _blur) * snoise(coord + fixed3(0.,_Time.y*.05*_Velocity, _Time.y*.01*+_Noise), power*16.);

		}
		clip(color);
		return fixed4(color, pow(max(color, 0.), 2.)*0.4 , pow(max(color, 0.), 3.)*0.15, color);
	}
	ENDCG
	}
	}
}

