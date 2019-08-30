
Shader "ShaderMan/Electro"
	{

	Properties{
	_Size("Size", Range(0.0,30.0)) = 12.0
	_Noise("Noise", Range(0.0,512.0)) = 512.0
	_Velocity("Velocity", Range(0.0,5)) = 1
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

		float _Size;
	float _Noise;
	float _Velocity;
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

	// Port of Humus Electro demo http://humus.name/index.php?page=3D&ID=35
// Not exactly right as the noise is wrong, but is the closest I could make it.
// Uses Simplex noise by Nikita Miropolskiy https://www.shadertoy.com/view/XsX3zB

/* Simplex code license
 * This work is licensed under a 
 * Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
 * http://creatifixedommons.org/licenses/by-nc-sa/3.0/
 *  - You must attribute the work in the source code 
 *    (link to https://www.shadertoy.com/view/XsX3zB).
 *  - You may not use this work for commercial purposes.
 *  - You may distribute a derivative work only under the same license.
 */


/* discontinuous pseudorandom uniformly distributed in [-0.5, +0.5]^3 */
fixed3 random3(fixed3 c) {
	fixed j = 512 *sin(dot(c,fixed3(17.0, 59.4, 15.0)));
	fixed3 r;
	r.z = frac(_Time.z*_Velocity);
	r.x = r.z;
	r.y = r.z;
	return r-0.5;
}

/* skew constants for 3d simplex functions */
const fixed F3 =  0.3333333;
const fixed G3 =  0.1666667;

/* 3d simplex noise */
fixed simplex3d(fixed3 p) {
	 /* 1. find current tetrahedron T and it's four vertices */
	 /* s, s+i1, s+i2, s+1.0 - absolute skewed (integer) coordinates of T vertices */
	 /* x, x1, x2, x3 - unskewed coordinates of p relative to each of T vertices*/
	 
	 /* calculate s and x */
	 fixed3 s = floor(p + dot(p, fixed3(F3,F3,F3)));
	 fixed3 x = p - s + dot(s, fixed3(G3,G3,G3));
	 
	 /* calculate i1 and i2 */
	 fixed3 e = step(fixed3(0.0,0.0,0.0), x - x.yzx);
	 fixed3 i1 = e*(1.0 - e.zxy);
	 fixed3 i2 = 1.0 - e.zxy*(1.0 - e);
	 	
	 /* x1, x2, x3 */
	 fixed3 x1 = x - i1 + G3;
	 fixed3 x2 = x - i2 + 2.0*G3;
	 fixed3 x3 = x - 1.0 + 3.0*G3;
	 
	 /* 2. find four surflets and store them in d */
	 fixed4 w, d;
	 
	 /* calculate surflet weights */
	 w.x = dot(x, x);
	 w.y = dot(x1, x1);
	 w.z = dot(x2, x2);
	 w.w = dot(x3, x3);
	 
	 /* w fades from 0.6 at the center of the surflet to 0.0 at the margin */
	 w = max(0.6 - w, 0.0);
	 
	 /* calculate surflet components */
	 d.x = dot(random3(s), x);
	 d.y = dot(random3(s + i1), x1);
	 d.z = dot(random3(s + i2), x2);
	 d.w = dot(random3(s + 1.0), x3);
	 
	 /* multiply d by w^4 */
	 w *= w;
	 w *= w;
	 d *= w;
	 
	 /* 3. return the sum of the four surflets */
	 return dot(d, fixed4(52.0,52.0,52.0,52.0));
}

fixed noise(fixed3 m) {
    return   0.5333333*simplex3d(m)
			+0.2666667*simplex3d(2.0*m)
			+0.1333333*simplex3d(4.0*m)
			+0.0666667*simplex3d(8.0*m);
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
	
  fixed2 uv = i.uv / 1;    
  uv = uv * 2. -1.;  
  fixed4 fragColor;
 
  fixed2 p = i.uv/1;
  fixed3 p3 = fixed3(p, _Time.y*0.4);    
    
  fixed3 noiseVar ;
  noiseVar.x = p3 * _Size + _Size;
  noiseVar.y = p3 * _Size + _Size;
  noiseVar.z = p3 * _Size + _Size;
  fixed intensity = noise(noiseVar);
  fixed t = clamp((uv.x * -uv.x * 0.16) + 0.15, 0., 1.);                         
  fixed y = abs(intensity * -t + uv.y);
    
  fixed g = pow(y, 0.2);
                          
  fixed3 col = fixed3(1.70, 1.48, 1.78);
  col = col * -g + col;                    
  col = col * col;
  col = col * col;
                          
  fragColor.rgb = col;                          
  fragColor.w = 1.;  
  return fragColor;
	}
	ENDCG
	}
  }
}

