Shader "Custom/ToonCustomShader"
{
    Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_RampTex("Ramp Texture", 2D) = "white" {}
		_CelShadingLevels("Cel shading levels", Float)=3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf CustomLambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex, _RampTex;
		float _CelShadingLevels;
        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		fixed4 LightingCustomLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float NdotL = max(0, dot(s.Normal, lightDir));
			/*NdotL = tex2D(_RampTex, float2(NdotL, 0.5)).r;
			fixed4 color;
			color.rgb= s.Albedo * NdotL * atten * _LightColor0.rgb;
			color.a = s.Alpha;
			return color;*/

			NdotL = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels );
			fixed4 color;
			color.rgb = s.Albedo * NdotL * atten * _LightColor0.rgb;
			color.a = s.Alpha;
			return color;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
