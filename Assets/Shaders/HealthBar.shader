Shader "Unlit/HealthBar"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        
        _healthbarColorFull ("HealthBar Full", Color ) = (0,1,0,1)
        _healthbarColorEmpty ("HealthBar Empty", Color ) = (1,0,0,1)
        _healthbarColorWarning ("HealthBar Warning", Color ) = (0,0,1,1)
        _bgColor ("HealthBar BG", Color ) = (0,0,0,0)
        _Health ("Health", Range(0,1)) = 1
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
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Health;
            float4 _healthbarColorFull;
            float4 _healthbarColorEmpty;
            float4 _healthbarColorWarning;
            float4 _bgColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertex.y += (1 - _Health) * cos(_Time * 30) * 0.2;
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float2 coords = i.uv;
                coords.x *= 8;

                float2 pointOnLineSeg = float2(clamp(coords.x, 0.5, 7.5), 0.5);
                float sdf = distance(coords, pointOnLineSeg) * 2 - 1;

                clip(-sdf);

                float borderSdf = sdf + 0.1;
                float pd = fwidth(borderSdf);
                
                float borderMask = 1 - saturate(borderSdf/pd);
                
                //return float4(sdf.xxx,1);
               
                //float healthbarMask = _Health > i.uv.x;
                float healthbarMaskSteps = _Health > floor(i.uv.x * 8) /8;

                 float3 healthbarColor = tex2D(_MainTex, float2(_Health, i.uv.y));
                                            //lerp(_healthbarColorEmpty, _healthbarColorFull, _Health);
                healthbarColor = lerp(healthbarColor, _healthbarColorWarning, (1 - _Health) * (sin(_Time * 3 * (1 - _Health))*0.5+0.5 ));
                
                float3 outColor =lerp(_bgColor, healthbarColor, healthbarMaskSteps);

                return float4( outColor * borderMask, 1);
                
                
                    

            }
            ENDCG
        }
    }
}