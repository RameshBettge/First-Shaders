Shader "_MyShaders/Tint"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Tint ("Tint", Color) = (1,1,1,1)
		_PositionalTint ("Positional Tint", Range(0,1)) = 0
		_TintStrength("Tint Strength", Range(0, 1)) = 0
	}

	SubShader
	{

		Tags
		{
			//Makes the object render after opaque objects (opaque objects only draw if nothing has been drawn on that spot before.)
			"Queue" = "Transparent"
		}

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha


			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				//Get the vertex positions in model space
				float4 vertex : POSITION;

				//Get the UV Coordinates
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				//SV_POSITION is the position of the vertex in projection Space
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			//Needed for  TRANSFORM_TEX, I think.
			float4 _MainTex_ST;
			float4 _Tint;
			float _PositionalTint;
			float _TintStrength;
			
			v2f vert (appdata v)
			{
				v2f o;

				//Transforms the vertex' position into projection space
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target //SV_target is the target. Without it the pixels won't be drawn.
			{
				//// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				float3 posTint = float3(col.x, 0, col.y);
				//Set Positional tint
				float3 posCol = float3(col.xyz * (1 - _PositionalTint) +  posTint * _PositionalTint);
				//Set general _Tint and copy the a from the texture.
				return float4(posCol * (1 - _TintStrength) + _Tint * _TintStrength, col.a);
			}
			ENDCG
		}
	}
}
