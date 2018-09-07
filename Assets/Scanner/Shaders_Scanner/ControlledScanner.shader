// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "_MyShaders/ControlledScanner"
{
	Properties
	{
		[Header(Diffuse)]
		_MainTex("Main Texture", 2D) = "White" {}
		_DetailTex("Detail Texture", 2D) = "White" {}

		[Header(Specular)]
		_SpecCol ("Color", Color) = (1, 1, 1, 1)
		_SpecStrength ("Strength", Range(0, 2)) = 0.2
		_SpecPow("Power", Range(1, 40)) = 3
	}
	SubShader
	{
		Tags { "Queue" = "Geometry-1"	"LightMode" = "ForwardBase"}

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"
			//#include "Lighting.cginc"
			//#include "AutoLight.cginc"

			

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float3 lightDir : TEXCOORD2;
			};

			float _ScannerStrength;

			sampler2D _MainTex;
			fixed4 _MainTex_ST;
			uniform fixed4 _DiffuseCol;
			sampler2D _DetailTex;
			fixed4 _DetailTex_ST;
			uniform fixed4 _DifDetailCol;

			uniform fixed4 _SpecCol;
			uniform float _SpecStrength;
			uniform float _SpecPow;
			
			uniform fixed4 _RimCol;
			uniform float _RimStrength;
			uniform float _RimPow;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.lightDir = WorldSpaceLightDir(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _DetailTex); //Necessary for woth textures??
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
			//Transparent but still occupies depth buffer
				fixed4 invis = (0,0,0,0);

			//Diffuse
				fixed NdotL = dot(i.normal, i.lightDir) * 0.5 + 1;
				//NdotL = max(1 - _ScannerStrength, NdotL);
				fixed4 dif = tex2D(_MainTex, i.uv) * _DiffuseCol * NdotL;
				dif.a = 1 - _ScannerStrength;

			//Specular
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz -
				i.worldPos.xyz);

				float3 refl = normalize(reflect(-i.lightDir, i.normal));
				float RdotV = max(0,dot(refl, viewDir));
				RdotV = pow(RdotV, _SpecPow);
				fixed4 spec = RdotV * _SpecCol * _SpecStrength;
				spec.a = 1;

			//Rim
			float NdotV = dot(i.normal, viewDir);
			fixed rim = _RimStrength * (1 - (0.5 * NdotV + 0.5));
			rim = pow(rim, _RimPow);

			//Add lighting types together
				fixed4 col = lerp(dif, invis, _ScannerStrength);
				fixed4 output = lerp(col, spec, RdotV);
				output = lerp(output, _RimCol, rim);
				output.a = max(output.a, rim);

				output = lerp(output, _DifDetailCol, 1 - tex2D(_DetailTex, i.uv).r);

				return output;
			}
			ENDCG
		}
	}
}
