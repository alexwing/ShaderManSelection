
Shader "ShaderMan/BoxBlur"
{
		Properties{
		_MainTex ("MainTex", 2D) = "white" {}
		_Density("Density", Range(1,256)) = 30
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
	float _Density;

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
			sampler2D _MainTex;


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
			
					fixed2 coordinates = i.uv;

					const fixed blurSize = _Density;
					const int range = int(floor(blurSize/2.0));
					
					fixed4 colors = fixed4(0,0,0,0);
					for (int x = -range; x <= range; x++) {
						for (int y = -range; y <= range; y++) {
							fixed4 color = tex2D(_MainTex, coordinates+fixed2(i.uv.x/x,i.uv.y/y));
							colors += color;
							
						}
					}
					 fixed4 finalColor = colors/pow(blurSize,2.0);
					 return finalColor;
				;
			}
			ENDCG
		}
	}
}

