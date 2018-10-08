// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
//从世界坐标_PosY开始，经过_fogRadius这么长，从原本的颜色（_mainColor）过度到雾化颜色（_fogColor）ps.相机背景颜色调成和_fogColor一样，去掉lighting设置里的skybox
//这样就实现了雾化渐变的效果
Shader "Unlit/fog_fade"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_mainColor("颜色",Color ) = (1,1,1,1)
		_fogColor("雾化颜色",Color ) = (1,0,0,1)
		_PosY("雾化开始点",Range(-100,100)) = 1
		_fogRadius("雾化半径",Range(-100,100)) = 2
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
				float4 vertex : SV_POSITION;
				float4 worldPos:TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _fogRadius;
			float _PosY;
			float4 _fogColor;
			float4 _mainColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyzw;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float fogValue = saturate( (_PosY-i.worldPos.y)/_fogRadius );//0到1的雾化渐变因子   注：_PosY不变，i.worldPos.y越小，fogValue越大，颜色就越接近_fogColor
				fixed4 col = tex2D(_MainTex, i.uv);
				col = col * _mainColor;//主材质的颜色
				return lerp(col,_fogColor,fogValue);//
			}
			ENDCG
		}
	}
}
