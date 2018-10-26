Shader "Unlit/gaussian_blur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_GaussianBlur("高斯模糊值",Range(0.001,0.01)) = 0.001
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _GaussianBlur;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				float2 tempUV = i.uv;

				fixed4 col = tex2D(_MainTex, tempUV);
				fixed4 col1 = tex2D(_MainTex, tempUV + float2(-_GaussianBlur,0));
				fixed4 col2 = tex2D(_MainTex, tempUV + float2(_GaussianBlur,0));
				fixed4 col3 = tex2D(_MainTex, tempUV + float2(0,-_GaussianBlur));
				fixed4 col4 = tex2D(_MainTex, tempUV + float2(0,_GaussianBlur));
				col = (col + col1 + col2 + col3 + col4)/5;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
