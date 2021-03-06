﻿Shader "_MyShaders/Unlit_TwoSided"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		[Toggle] _disableTransparency("disable Transparency", float) = 0
		[Toggle] _isGrayscale("isGrayscale", float) = 0
	}
	SubShader
	{
		Tags { 
		"Queue" = "Transparent"
		}

		Cull Off

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

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
			float4 _MainTex_ST;
			float _disableTransparency;
			float _isGrayscale;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				col.a = max(col.a, _disableTransparency);
				float average = (col.r + col.g + col.b) / 3;
				fixed4 gray = fixed4(average, average, average, col.a);

				col = col * (1 - _isGrayscale) + gray * _isGrayscale;
				return col;
			}
			ENDCG
		}
	}
}
