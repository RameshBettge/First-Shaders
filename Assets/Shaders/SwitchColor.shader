Shader "_MyShaders/SwitchColor"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Amount ("Mix-Amount", Range(0,1)) = 0
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
			float _Amount;
			
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

				fixed4 firstSwitch = fixed4(col.b, col.r, col.g, col.a);
				fixed4 secondSwitch = fixed4(col.g, col.b, col.r, col.a);

				col = col * (1 - _Amount) + firstSwitch * _Amount;


				return col;
			}
			ENDCG
		}
	}
}
