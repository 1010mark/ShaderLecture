Shader "Unlit/CameraDistance"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent" 
            "Queue"="Transparent" 
        }   // 改変部 2
        Blend SrcAlpha OneMinusSrcAlpha     // 改変部 3
        LOD 100

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
                float3 viewPos : TEXCOORD1; // 改変部 3
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.viewPos = UnityObjectToViewPos(v.vertex).xyz; // 改変部 3
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float dist = length(i.viewPos);
                float alpha = saturate(1 - dist);
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a = alpha;
                return col;
            }
            ENDCG
        }
    }
}
