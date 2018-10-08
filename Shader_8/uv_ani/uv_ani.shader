Shader "Unlit/uv_ani"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Row("行数",Range(1,100)) = 1
		_Col("列数",Range(1,100)) = 1
		_AniSpeed("播放速度",Range(1,100)) = 1
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
			float _Row;
			float _Col;
			float _AniSpeed;
			
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
				float time = floor(_Time.y * _AniSpeed);
				float col = floor(time / _Col);//随时间递进，算出当前是第几列   后面uv值超过1 之后uv会取余
				float row = floor(time / (_Col*_Col));//1行所需时间是 一列所需时间的_Col 倍
				
				i.uv.x = (i.uv.x + col)/_Col;//(i.uv.x/_Col)+col*(1/_Col);
				i.uv.y = ((i.uv.y-1 + row)/_Row);
				// sample the texture
				// i.uv = float2(i.uv.x/_Col,i.uv.y/_Row);
				fixed4 color = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, color);
				return color;
			}
			ENDCG
		}
	}
}
