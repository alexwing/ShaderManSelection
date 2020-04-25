
Shader "ShaderMan/StarrySky2"
{

    Properties{
        //Properties
                _FogColor("Fog Color", Color) = (0,0,0,0)
                _BackgroundColor("Background Color", Color) = (0,0,0,0)
                _StarColor("Star Color", Color) = (0,0,0,0)
                _VelocityFog("VelocityFog", Range(-10,10)) = 0.0
                _StarQuantity("StarQuantity", Range(-10,10)) = 0.0

                _SizeStars("Size Stars", Range(0.0,10.0)) = 1
                _StarVelocity("Start Velocity", Range(0.0,10.0)) = 1
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
    fixed4 _FogColor;
    fixed4 _BackgroundColor;
    fixed4 _StarColor;
    float _SizeStars;

    float _VelocityFog;
    float _StarQuantity;
    float _StarVelocity;

    struct VertexOutput {
    fixed4 pos : SV_POSITION;
    fixed2 uv : TEXCOORD0;
    //VertexOutput
    };

    //Variables

    // By Alexander Lemke, 2015
// Voronoi and fracal noise functions based on iq's https://www.shadertoy.com/view/MslGD8

fixed Hash(in fixed2 p)
{
    fixed h = dot(p, fixed2(12.9898, 78.233));
    return -1.0 + 2.0 * frac(sin(h) * 43758.5453);
}

fixed2 Hash2D(in fixed2 p)
{
    fixed h = dot(p, fixed2(12.9898, 78.233));
    fixed h2 = dot(p, fixed2(37.271, 377.632));
    return -1.0 + 2.0 * fixed2(frac(sin(h) * 43758.5453), frac(sin(h2) * 43758.5453));
}

fixed Noise(in fixed2 p)
{
    fixed2 n = floor(p);
    fixed2 f = frac(p);
    fixed2 u = f * f * (3.0 - 2.0 * f);

    return lerp(lerp(Hash(n), Hash(n + fixed2(1.0, 0.0)), u.x),
               lerp(Hash(n + fixed2(0.0, 1.0)), Hash(n + fixed2(1.0,1.0)), u.x), u.y);
}

fixed FractalNoise(in fixed2 p)
{
    p *= 5.0;
    fixed2 m = fixed2(1.6,  1.2);
    fixed2 f = 0.5000 * Noise(p);
    p = m * p;
    f += 0.2500 * Noise(p); p = m * p;
    f += 0.1250 * Noise(p); p = m * p;
    f += 0.0625 * Noise(p); p = m * p;

    return f;
}

fixed3 Voronoi(in fixed2 p)
{
    fixed2 n = floor(p);
    fixed2 f = frac(p);

    fixed2 mg, mr;

    fixed md = 8.0;
    [unroll(100)]
for (int j = -1; j <= 1; ++j)
    {
        [unroll(100)]
for (int i = -1; i <= 1; ++i)
        {
            fixed2 g = fixed2(fixed(i), fixed(j));
            fixed2 o = Hash2D(n + g);

            fixed2 r = g + o - f;
            fixed d = dot(r, r);

            if (d < md)
            {
                md = d;
                mr = r;
                mg = g;
            }
        }
    }
    return fixed3(md, mr);
}

fixed4 ApplyFog(in fixed2 texCoord)
{
    fixed4 finalColor = _FogColor;

    fixed2 samplePosition = (4.0 * texCoord.xy / 1) + fixed2(0.0, _Time.y * _VelocityFog);
    fixed fogAmount = FractalNoise(samplePosition) * _FogColor.a;

    fixed4 fogColor = fixed4(texCoord.xy / 1 + fixed2(0.5, 0.0), 1,1);
    finalColor = fogColor * fogAmount * fixed4(sin(_Time.y) * 0.00125 + 0.75, sin(_Time.y) * 0.00125 + 0.75, sin(_Time.y) * 0.00125 + 0.75, sin(_Time.y) * 0.00125 + 0.75);
    finalColor = finalColor * _FogColor;
    return finalColor;
}

fixed4 AddStarField(fixed2 samplePosition, fixed threshold)
{
    fixed3 starValue = Voronoi(samplePosition / _SizeStars);
    if (starValue.x < threshold)
    {
        fixed power = 1.0 - (starValue.x / threshold);
        return fixed4(power * power * power * _StarColor.a * _StarColor.x,power * power * power * _StarColor.a * _StarColor.y,power * power * power * _StarColor.a * _StarColor.z, power * power * power * _StarColor.a);
    }
    return fixed4(0.0,0.0,0.0,0.0);
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

    fixed maxResolution = max(1, 1);

    fixed4 finalColor = ApplyFog(i.uv);

    // Add Star Fields
    fixed2 samplePosition = (i.uv / maxResolution) + fixed2(0.0, _Time.y * 0.01 / _StarVelocity);
    finalColor += AddStarField(samplePosition * 16.0, 0.00125 * _StarQuantity) + _BackgroundColor;

    samplePosition = (i.uv / maxResolution) + fixed2(0.0, _Time.y * 0.004 / _StarVelocity);
    finalColor += AddStarField(samplePosition * 20.0, 0.00125 * _StarQuantity) + _BackgroundColor;

    samplePosition = (i.uv / maxResolution) + fixed2(0.0, _Time.y * 0.0005 + 0.5 / _StarVelocity);
    finalColor += AddStarField(samplePosition * 8.0, 0.0007 * _StarQuantity) + _BackgroundColor;

    return finalColor;

    }
    ENDCG
    }
    }
}

