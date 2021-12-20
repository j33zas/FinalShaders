// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Final/WaterStream"
{
	Properties
	{
		_Streams("Streams", 2D) = "white" {}
		_Color2("Color 2", Color) = (0.7735849,0.7735849,0.7735849,1)
		_Watercolor1("Water color 1", Color) = (0.1131185,0.6100909,0.7735849,1)
		_Watercolor2("Water color 2", Color) = (0,0,0,0)
		_Timescale("Time scale", Float) = 0.5
		_Streamscale("Stream scale", Float) = 2
		_NoiseTexture("Noise Texture", 2D) = "white" {}
		_Distortionstrength("Distortion strength", Range( 0 , 1)) = 0.1336516
		_Smoothness("Smoothness", Float) = 0.6117647
		_smoothnessNoise("smoothness Noise", Float) = 6.67
		_Noisesmoothnessintensity("Noise smoothness intensity", Range( 0 , 5)) = 0.577206
		_Watercolorlerpstrength("Water color lerp strength", Float) = 0.79
		_FresnelBias("Fresnel Bias", Range( -1 , 1)) = 0
		_FresnelScale("Fresnel Scale", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _Watercolor1;
		uniform float4 _Watercolor2;
		uniform sampler2D _NoiseTexture;
		uniform float _Timescale;
		uniform float _Watercolorlerpstrength;
		uniform float4 _Color2;
		uniform sampler2D _Streams;
		uniform float _Streamscale;
		uniform float _Distortionstrength;
		uniform float _smoothnessNoise;
		uniform float _Noisesmoothnessintensity;
		uniform float _Smoothness;
		uniform float _FresnelBias;
		uniform float _FresnelScale;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime19 = _Time.y * _Timescale;
			float2 panner17 = ( mulTime19 * float2( 0,1 ) + i.uv_texcoord);
			float4 tex2DNode21 = tex2D( _NoiseTexture, panner17 );
			float4 lerpResult46 = lerp( _Watercolor1 , _Watercolor2 , saturate( ( tex2DNode21.r * _Watercolorlerpstrength ) ));
			float2 temp_cast_0 = (_Streamscale).xx;
			float mulTime9 = _Time.y * _Timescale;
			float2 temp_cast_1 = (mulTime9).xx;
			float2 uv_TexCoord1 = i.uv_texcoord * temp_cast_0 + temp_cast_1;
			float2 temp_cast_2 = (tex2DNode21.r).xx;
			float2 lerpResult22 = lerp( uv_TexCoord1 , temp_cast_2 , _Distortionstrength);
			float4 tex2DNode8 = tex2D( _Streams, lerpResult22 );
			float4 lerpResult11 = lerp( lerpResult46 , _Color2 , tex2DNode8.r);
			float4 Albedo14 = lerpResult11;
			o.Albedo = Albedo14.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV53 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode53 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV53, 5.23 ) );
			float smoothness28 = saturate( ( ( ( ( ( 1.0 - tex2DNode8.r ) / _smoothnessNoise ) * saturate( ( tex2DNode21.r * _Noisesmoothnessintensity ) ) ) * _Smoothness ) + fresnelNode53 ) );
			o.Smoothness = smoothness28;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
7;7;1906;1004;786.7236;875.9814;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;10;-2848,-224;Inherit;False;Property;_Timescale;Time scale;4;0;Create;True;0;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;19;-2656,176;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;18;-2656,48;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-2656,-64;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-2448,-320;Inherit;False;Property;_Streamscale;Stream scale;5;0;Create;True;0;0;0;False;0;False;2;1.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;17;-2400,-64;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-2688,-224;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-2224,-64;Inherit;True;Property;_NoiseTexture;Noise Texture;6;0;Create;True;0;0;0;False;0;False;-1;None;e9c51e3be909c8a43ae584dbb6db900d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-2224,128;Inherit;False;Property;_Distortionstrength;Distortion strength;7;0;Create;True;0;0;0;False;0;False;0.1336516;0.204;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2224,-320;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1.71;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;22;-1856,-160;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1648,144;Inherit;False;Property;_Noisesmoothnessintensity;Noise smoothness intensity;10;0;Create;True;0;0;0;False;0;False;0.577206;0.81;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-1632,-160;Inherit;True;Property;_Streams;Streams;0;0;Create;True;0;0;0;False;0;False;-1;6aba8712b5ed0b64896405d0bd25a3e0;6aba8712b5ed0b64896405d0bd25a3e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1344,96;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1344,16;Inherit;False;Property;_smoothnessNoise;smoothness Noise;9;0;Create;True;0;0;0;False;0;False;6.67;1.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-1312,-160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2313,-448;Inherit;False;Property;_Watercolorlerpstrength;Water color lerp strength;11;0;Create;True;0;0;0;False;0;False;0.79;1.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;52;-1216,96;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;36;-1120,0;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;48;-2004.188,-388.7516;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-960,224;Inherit;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;0;False;0;False;0.6117647;2.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-960,0;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1936,-512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1088,288;Inherit;False;Property;_FresnelBias;Fresnel Bias;12;0;Create;True;0;0;0;False;0;False;0;-0.01176471;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1088,416;Inherit;False;Constant;_Fresnelpower;Fresnel power;12;0;Create;True;0;0;0;False;0;False;5.23;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1088,352;Inherit;False;Property;_FresnelScale;Fresnel Scale;13;0;Create;True;0;0;0;False;0;False;0.1;1.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;53;-800,288;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-2272,-736;Inherit;False;Property;_Watercolor2;Water color 2;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.1417319,0.1417319,0.6132076,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-2272,-896;Inherit;False;Property;_Watercolor1;Water color 1;2;0;Create;True;0;0;0;False;0;False;0.1131185,0.6100909,0.7735849,1;0.5235849,0.883732,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;51;-1808,-512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-752,0;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1856,-320;Inherit;False;Property;_Color2;Color 2;1;0;Create;True;0;0;0;False;0;False;0.7735849,0.7735849,0.7735849,1;0.8113208,0.8113208,0.8113208,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-544,0;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;-1744,-832;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;-1312,-416;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;58;-352,0;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-208,0;Inherit;False;smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1072,-416;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;18.63839,-643.2938;Inherit;False;28;smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;34.63841,-723.2941;Inherit;False;14;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;242.6384,-723.2941;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Final/WaterStream;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;10;0
WireConnection;17;0;16;0
WireConnection;17;2;18;0
WireConnection;17;1;19;0
WireConnection;9;0;10;0
WireConnection;21;1;17;0
WireConnection;1;0;15;0
WireConnection;1;1;9;0
WireConnection;22;0;1;0
WireConnection;22;1;21;1
WireConnection;22;2;23;0
WireConnection;8;1;22;0
WireConnection;43;0;21;1
WireConnection;43;1;35;0
WireConnection;26;0;8;1
WireConnection;52;0;43;0
WireConnection;36;0;26;0
WireConnection;36;1;38;0
WireConnection;48;0;21;1
WireConnection;44;0;36;0
WireConnection;44;1;52;0
WireConnection;49;0;48;0
WireConnection;49;1;50;0
WireConnection;53;1;54;0
WireConnection;53;2;55;0
WireConnection;53;3;56;0
WireConnection;51;0;49;0
WireConnection;31;0;44;0
WireConnection;31;1;32;0
WireConnection;57;0;31;0
WireConnection;57;1;53;0
WireConnection;46;0;3;0
WireConnection;46;1;45;0
WireConnection;46;2;51;0
WireConnection;11;0;46;0
WireConnection;11;1;2;0
WireConnection;11;2;8;1
WireConnection;58;0;57;0
WireConnection;28;0;58;0
WireConnection;14;0;11;0
WireConnection;0;0;13;0
WireConnection;0;4;27;0
ASEEND*/
//CHKSM=B36BEE1916045C413BBD004B967CB35BD012D198