Shader "Unlit/MyFirstShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MyFloat ("A floating point numner", float) = 4
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (0,0,0,1)
        _ColorStart("Color Start", range(0,1)) = 0
        _ColorEnd("Color End", range(0,1)) = 1
        _Scale("Scale UV", float) = 1
        _Offset("Offset UV", float) = 1
        _ScaleExample("Example", range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            //#define PI UNITY_PI
            #define TAU UNITY_TWO_PI
            
            struct appdata //input for the vertex shader
            {               
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
                        //output of the vertex shader
            struct v2f //input the frag shader
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Scale;
            float _Offset;
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                //v.vertex.y += sin(_Time.y * 10 + v.vertex.x*4) * .3;
               // v.vertex.x += sin(_Time.y * 10 + v.vertex.y*4) * .3;
                //v.vertex.xyz *= -1;
                //v.vertex.xyz += 0.2 * v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = mul(v.normal, unity_WorldToObject); //mul(UNITY_MATRIX_M, v.normal);  //Does the same as UnityObjectToClipPos(v.normal);
                o.uv = (v.uv + _Offset) * _Scale;
                return o;
            }
            //per texel
            float4 frag (v2f i) : SV_Target
            {
                //float4 col = tex2D(_MainTex, i.uv);
                //col = float4(0,col.a,0 ,1);
                
                /*float myVal = col.G;
                myVal       = col.Y;
                myVal       = col[1]; 
                myVal       = col.V;*/
                //float4(InverseLerp(3, 9, 6).xxx,1);
                //float t = saturate(InverseLerp(_ColorStart,_ColorEnd,i.uv.x));
                //float t = abs(frac(i.uv.x * 5) * 2 -1);
                float xOffset = cos(i.uv.y * TAU * 8) * 0.01;
                float t = cos((i.uv.x * xOffset + _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;;
                t*= 1-i.uv.y;
                float4 outColor = lerp(_ColorA,_ColorB,t);
                return outColor;
                return float4(i.uv,0,1);
            }
            ENDCG
        }
    }
}