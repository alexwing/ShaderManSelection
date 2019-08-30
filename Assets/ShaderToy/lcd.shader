Shader "ShaderMan/lcd"
{
	Properties
	{
		_Density("Density", Range(2,2000)) = 30
		_Brightness("Density", Range(2,2000)) = 30
		_MainTex("MainTex", 2D) = "white" {}
	}
		SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

	float _Density;

		v2f vert(float4 pos : POSITION, float2 uv : TEXCOORD0)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(pos);
			o.uv = uv * _Density;
			return o;
		}
	//Variables
	sampler2D _MainTex;



	fixed4 frag(v2f i) : SV_Target
	{
		// Get pos relative to 0-1 screen space
		fixed2 uv = i.uv / 1;

	// Darken every 3rd horizontal strip for scanline


	fixed sclV = 0.;

		// Map tex2D to 0-1 space
		fixed4 texColor = tex2D(_MainTex, i.uv/ _Density);

		// Default lcd colour (affects brightness)
		fixed pb = 0.4;
		fixed4 lcdColor = fixed4(pb,pb,pb,1.0);

		// Change every 1st, 2nd, and 3rd vertical strip to RGB respectively
		int px = int(fmod(i.uv.x,4.0));
		if (px == 1)
			lcdColor.r = 1.0;
		else if (px == 2)
			lcdColor.g = 1.0;
		else if (px == 3)
			lcdColor.b = 1.0;
		else
			lcdColor.rgb = fixed3(sclV, sclV, sclV);


		if (int(fmod(i.uv.y, 3.0)) == 0) {
			lcdColor.rgb = fixed3(sclV, sclV, sclV);
			
		}


		fixed4 output;

		output = lcdColor;
		// output *= smoothstep(i.uv.x, i.uv.y, 0.001);

		output *=texColor;


		return output;
			}
			ENDCG
		}
	}
}