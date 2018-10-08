Shader "Unlit/flagShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_pinlv("频率",range(0.1,10)) = 1
		_flagColor("旗帜的颜色",Color) = (1,1,1,1)
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
			float _pinlv;
			fixed4 _flagColor;

			v2f vert (appdata v)
			{
				v2f o;
				if( v.uv.x > 0.01)
				{
					v.vertex.y = sin(v.uv.x*3.14*2 * _pinlv + _Time.z + v.uv.y*2) ;
				}


				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				//return fixed4(i.uv.x,0,0,1);
				return col * _flagColor;
			}
			ENDCG
		}
	}
}
