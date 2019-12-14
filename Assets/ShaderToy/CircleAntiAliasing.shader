Shader "ShaderMan/Circle Anti-Aliasing"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white"{}
		_BoundColor("Bound Color", Color) = (0,0,0,1)
		_BgColor("Background Color", Color) = (1,1,1,0)
		_circleSizePercent("Circle Size Percent", Range(0, 100)) = 50
		_border("Anti Alias Border Threshold", Range(0.001, 1000)) = 1
		_Oval("Oval", Range(0,2)) = 1
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

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			float _border;
			float _Oval;
			uniform sampler2D  _MainTex;
			fixed4 _BoundColor;
			fixed4 _BgColor;
			float _circleSizePercent;

			struct VertexOutput
			{
				float2 uv : TEXCOORD0;
			};

			VertexOutput vert(
				float4 vertex : POSITION, // vertex position input
				float2 uv : TEXCOORD0, // texture coordinate input
				out float4 outpos : SV_POSITION // clip space position output
			)
			{
				VertexOutput o;
				o.uv = uv;
				outpos = UnityObjectToClipPos(vertex);
				return o;
			}



			fixed4 frag(VertexOutput i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_Target
			{
				float4 col;
				_ScreenParams.x *= _Oval;
				screenPos.x *= _Oval ;
				float2 center = _ScreenParams.xy / 2;

				float maxradius = length(center);

				float radius = maxradius * (_circleSizePercent / 100);
	
				//center *= _Oval;
				float dis = distance(screenPos.xy, center);

				float aliasVal = smoothstep(radius + _border, radius - _border, dis);
				col = lerp(_BgColor, _BoundColor, aliasVal);
				
				
				fixed3 video = fixed3(tex2D(_MainTex, i.uv).xyz);
				return fixed4(video - col, 1);

			}
			ENDCG
		}
	}
}
