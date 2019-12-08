Shader "AKStudio/Lava3" {
Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
       
        _AddTex ("Add texture", 2D) = "white" {}
        _AddMask ("Mask", 2D) = "white" {}

        _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5				
		_Speed("Mask Texture Speed", Range(0,10)) = 1.0
}

SubShader {
        Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
        LOD 200
       
CGPROGRAM
#pragma surface surf Lambert alphatest:_Cutoff

sampler2D _MainTex;
sampler2D _AddTex;
sampler2D _AddMask;

fixed4 _Color;
float _Speed;

struct Input {
    float2 uv_MainTex;
    float2 uv_AddTex;
    float2 uv_AddMask;	
	
	float2 tPos;
};


void surf (Input IN, inout SurfaceOutput o) {
		float2 tPos = IN.uv_MainTex.xy;
		tPos += _Time * _Speed * 0.01;
		
		
		fixed4 c = tex2D(_MainTex, tPos);       
        fixed4 ca = tex2D(_AddTex, IN.uv_AddTex) * _Color;
        float factor = tex2D(_AddMask, IN.uv_AddMask).a;
        c = lerp(ca, c, 1 - factor);
       
        o.Albedo = c.rgb;
        o.Alpha = lerp(c.a, ca.a, factor);
}

ENDCG
}

Fallback "Transparent/Cutout/VertexLit"
}
