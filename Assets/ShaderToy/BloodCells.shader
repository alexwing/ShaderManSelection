
Shader "ShaderMan/BloodCells"
	{

	Properties{
	f("F", Range(0.0,1)) = 0.25
	_scale("scale", Range(0.0,1)) = 0.25
	_scale2("scale2", Range(0.0,150)) = 125


		_R("R", Range(0.0,255)) = 0.0
		_G("G", Range(0.0,255)) = 0.0
		_B("B", Range(0.0,255)) = 0.0
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

	/**
 Just fooling around basicly. Some sort of bloodstream. 
*/


// http://iquilezles.org/www/articles/smin/smin.htm
fixed smin( fixed a, fixed b, fixed k )
{
    fixed h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return lerp( b, a, h ) - k*h*(1.0-h);
}

fixed cells(fixed2 uv){  // Trimmed down.
    uv = lerp(sin(uv + fixed2(1.57, 0)), sin(uv.yx*1.4 + fixed2(1.57, 0)), .75);
    return uv.x*uv.y*.3 + .7;
}

/*
fixed cells(fixed2 uv)
{
    fixed sx = cos(uv.x);
    fixed sy = sin(uv.y);
    sx = lerp(sx, cos(uv.y * 1.4), .75);
    sy = lerp(sy, sin(uv.x * 1.4), .75);
    return .3 * (sx * sy) + .7;
}
*/

const fixed BEAT = 4.0;

fixed4 fragColor;
fixed f;
float _scale;
float _scale2;

float _R;
float _G;
float _B;
fixed fbm(fixed2 uv)
{
    
   // fixed f = 200.0;
    fixed2 r = (fixed2(.9, .45));    
    fixed2 tmp;
    fixed T = 100.0 + _Time.y * 1.3;
    T += sin(_Time.y * BEAT) * .1;
    // layers of cells with some scaling and rotation applied.
    for (int i = 1; i < 8; ++i)
    {
        fixed fi = fixed(i);
        uv.y -= T * .5;
        uv.x -= T * .4;
        tmp = uv;
        
        uv.x = tmp.x * r.x - tmp.y * r.y; 
        uv.y = tmp.x * r.y + tmp.y * r.x; 
        fixed m = cells(uv);
        f = smin(f, m, .07);
    }


    return 1. - f;
}

fixed3 g(fixed2 uv)
{
    fixed2 off = fixed2(0.0, .03);
    fixed t = fbm(uv);
    fixed x = t - fbm(uv + off.yx);
    fixed y = t - fbm(uv + off);
    fixed s = .0025;
    fixed3 xv = fixed3(s, x, 0);
    fixed3 yv = fixed3(0, y, s);
    return normalize(cross(xv, -yv)).xzy;
}

fixed3 ld = normalize(fixed3(1.0, 2.0, 3.));





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
	
	fixed2 uv = i.uv / 1;
    uv -= fixed2(0.5,0.5);  
    fixed a = 1 / 1;
    uv.y /= a;
    fixed2 ouv = uv;
    fixed B = sin(_Time.y * BEAT);
    uv = lerp(uv, uv * sin(B), _scale);
    fixed2 _uv = uv * _scale2;
    fixed f = fbm(_uv);
    
    // base color
    return fixed4(f,f,f,f);
    fragColor.rgb *= fixed3(1., .3 + B * .05, 0.1 + B * .05);
    
    fixed3 v = normalize(fixed3(uv, 1.));
    fixed3 grad = g(_uv);
    
    // spec
    fixed3 H = normalize(ld + v);
    fixed S = max(0., dot(grad, H));
    S = pow(S, 4.0) * .2;
    fragColor.rgb += S * fixed3(.4, .7, .7);
    // rim
    fixed R = 1.0 - clamp(dot(grad, v), .0, 1.);
    fragColor.rgb = lerp(fragColor.rgb, fixed3(.8, .8, 1.), smoothstep(-.2, 2.9, R));
    // edges
    fragColor.rgb = lerp(fragColor.rgb, fixed3(0.,0.,0.), smoothstep(.45, .55, (max(abs(ouv.y * a), abs(ouv.x)))));
    



    // contrast
    return smoothstep(.0, 1., fragColor);

	}
	ENDCG
	}
  }
}

