Shader "Custom/NormalDisplacement" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Normal("Normal map", 2D) = "bump" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_DisplGuide("Displacement guide", 2D) = "white" {}
		_DisplAmount("Displacement amount", float) = 0
		_DisplSpeed("Displacement speed", float) = 0.5
		_FadeParam("Fade parameter", Range(0.01,3.0)) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite off
		Cull off

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Normal;
		sampler2D _DisplGuide;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Normal;
			float2 uv_DisplGuide;
			float4 screenPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _DisplSpeed;
		float _DisplAmount;
		float _FadeParam;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		sampler2D _CameraDepthTexture;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float2 displ = tex2D(_DisplGuide, IN.uv_DisplGuide + _Time.y * _DisplSpeed).xy;
			displ = ((displ * 2) - 1) * _DisplAmount;
			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal + _Time.y * _DisplSpeed + displ)) + UnpackNormal(tex2D(_Normal, IN.uv_Normal * 2 - _Time.y * _DisplSpeed + displ));
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			float sceneZ = LinearEyeDepth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos)));
			float partZ = IN.screenPos.z;
			float fade = saturate(_FadeParam * (sceneZ - partZ));
			o.Alpha = c.a * fade;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
