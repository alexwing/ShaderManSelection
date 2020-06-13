
Shader "ShaderMan/CausticColours"
{

	Properties{
	//	_MainTex("MainTex", 2D) = "white"{}
	_Density("Density", Range(0.0,5.0)) = 0.0
	_Velocity("Velocity", Range(0.0,5.0)) = 0.5
	MAX_ITER("Iterations", Range(0,32)) = 4
	TAU("Scale", Range(0,32)) = 6.28318530718
	_Alpha("Alpha", Range(0.0,1.0)) = 1.0
	_R("R", Range(0.0,1)) = 0.0
	_G("G", Range(0.0,1)) = 0.0
	_B("B", Range(0.0,1)) = 0.0

		//_MainTex("MainTex", 2D) = "white" {}

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

		//	uniform sampler2D  _MainTex;

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
			float _Density;
			float _R;
			float _G;
			float _B;
			float _Alpha;
			float _Velocity;

			int MAX_ITER;

			float TAU;





			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				//VertexFactory
				return o;
			}
			fixed4 frag(VertexOutput i2) : SV_Target
			{

				fixed time = _Time.y * _Velocity + 23.0;
			// uv should be the 0-1 uv of tex2D...
			fixed2 uv = i2.uv / 1;


			fixed2 p = fmod(uv * TAU, TAU) - 250.0;

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
			fixed3 colour = fixed3(pow(abs(c), 1.0), pow(abs(c),1.0), pow(abs(c), 1.0));
			//fixed3 colour = fixed3(c, c, c);
			colour = clamp(colour + fixed3(0.0, 0.35, 0.5), 0.0, pow(abs(c), 8.0));



			colour.r += _R * c;
			colour.g += _G * c;
			colour.b += _B * c;
			colour = colour * _Alpha;

			colour.r += _R * _Density;
			colour.g += _G * _Density;
			colour.b += _B * _Density;


			// normalized pixel coordinates

			// pattern
			fixed f = sin(p.x + sin(2.0 * p.y + _Time.y)) +
				sin(length(p) + _Time.y) +
				0.5 * sin(p.x * 2.5 + _Time.y);

			// color
			fixed3 col = 0.7 + 0.3 * cos(f + fixed3(0, 2.1, 4.2));

			// putput to screen
			fixed3 video = col;



			//fixed3 video = fixed3(tex2D(_MainTex, uv).xyz);

			return  fixed4(clamp(video + colour, video + colour, video + colour),1);
		}
	ENDCG
	}
	}
}

