Shader "Custom/TexBlending"
{
    Properties
    {
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		_ColorA("Terrain Color A", Color) = (1,1,1,1)
		_ColorB("Terrain Color B", Color) = (1,1,1,1)
		_RTexture("Red Channel Texture", 2D) = ""{}
		_GTexture("Green Channel Texture", 2D) = ""{}
		_BTexture("Blue Channel Texture", 2D) = ""{}
		_ATexture("Alpha Channel Texture", 2D) = ""{}
		_BlendTexture("Blend Texture", 2D) = ""{}

       
       
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
    
        #pragma surface surf Lambert

     
        #pragma target 3.5

        sampler2D _MainTex;
		float4 _MainTint, _ColorA, _ColorB;
		sampler2D _RTexture, _GTexture, _BTexture, _ATexture, _BlendTexture;

        struct Input
        {
			float2 uv_RTexture;
			float2 uv_GTexture;
			float2 uv_BTexture;
			float2 uv_ATexture;
			float2 uv_BlendTexture;

        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        
        UNITY_INSTANCING_BUFFER_START(Props)
            
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
			float4 blendData = tex2D(_BlendTexture, IN.uv_BlendTexture);
			float4 rData = tex2D(_RTexture, IN.uv_RTexture);
			float4 gData = tex2D(_GTexture, IN.uv_GTexture);
			float4 bData = tex2D(_BTexture, IN.uv_BTexture);
			float4 aData = tex2D(_ATexture, IN.uv_ATexture);

			float4 finalColor;
			finalColor = lerp(rData, gData, blendData.g);
			finalColor = lerp(finalColor, bData, blendData.b);
			finalColor = lerp(finalColor, aData, blendData.a);
			finalColor.a = 1;
			float4 terrainLayers = lerp(_ColorA, _ColorB, blendData.r);
			finalColor *= terrainLayers;
			finalColor - saturate(terrainLayers);
            o.Albedo = finalColor.rgb*_MainTint.rgb;
            
           
            o.Alpha = finalColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
