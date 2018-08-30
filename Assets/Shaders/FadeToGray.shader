Shader "_MyShaders/FadeToGray"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_amount("Amount", Range(0, 1)) = 0
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
			float _amount;
			
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
				col.rgb = lerp(col.rgb, fixed3(0.2f, 0.2f, 0.2f), _amount);
				return col;
			}
			ENDCG
		}
	}
}
