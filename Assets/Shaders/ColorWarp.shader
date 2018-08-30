Shader "_MyShaders/ColorWarp"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			uniform float _Amount;

			uniform float state0;
			uniform float state1;
			uniform float state2;
			uniform float state3;
			uniform float state4;
			uniform float state5;


			
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

				float stage = _Time.y % 3;

				fixed4 firstSwitch = fixed4(col.b, col.r, col.g, col.a);
				fixed4 secondSwitch = fixed4(col.g, col.b, col.r, col.a);
				fixed4 thirdSwitch = fixed4(col.r, col.b, col.g, col.a);
				fixed4 fourthSwitch = fixed4(col.g, col.r, col.b, col.a);
				fixed4 fifthSwitch = fixed4(col.b, col.g, col.r, col.a);



				//col = col * (1 - _Amount) + firstSwitch * _Amount;
				fixed4 warpedCol = (col * state0 + firstSwitch * state1 + secondSwitch * state2
				    + thirdSwitch * state3  + fourthSwitch * state4 + fifthSwitch * state5);

				//col =  warpedCol * _Amount + col * (1 _Amount);
				col =  warpedCol * _Amount + col * (1 - _Amount);

				return col;
			}
			ENDCG
		}
	}
}
