// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Final/Rain"
{
	Properties
	{
		_RainMask("RainMask", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_Streakspeed("Streak speed", Float) = 1
		_AvoidMaskcollision("Avoid Mask collision", Range( 0 , 1)) = 0.71
		_Distortintensity("Distort intensity", Float) = 2
		_Distortstrength("Distort strength", Range( 0 , 1)) = 0
		_Distorttexture("Distort texture", 2D) = "white" {}
		_SplochScale("Sploch Scale", Float) = 5.03
		_BigSplochsize("Big Sploch size", Range( 0 , 1)) = 0.6999048
		_Smallsplochsize("Small sploch size", Range( 0 , 1)) = 0.3508353
		_SplashPower("Splash Power", Range( 0 , 1)) = 1
		[HDR]_Raincolor("Rain color", Color) = (0,0,0,0)
		_ColorIntensity("Color Intensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
		};

		uniform float _ColorIntensity;
		uniform float4 _Raincolor;
		uniform sampler2D _RainMask;
		uniform float _Streakspeed;
		uniform float2 _Tiling;
		uniform sampler2D _Distorttexture;
		uniform float _Distortstrength;
		uniform float _Distortintensity;
		uniform float _AvoidMaskcollision;
		uniform float _SplochScale;
		uniform float _BigSplochsize;
		uniform float _SplashPower;
		uniform float _Smallsplochsize;


		float2 voronoihash101( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi101( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -3; j <= 3; j++ )
			{
				for ( int i = -3; i <= 3; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash101( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_32_0 = ( _Time.y * _Streakspeed );
			float2 _Vector0 = float2(0,1);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform18 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float2 appendResult19 = (float2(transform18.x , transform18.y));
			float2 panner28 = ( temp_output_32_0 * _Vector0 + ( appendResult19 * _Tiling ));
			float2 UV7_g7 = i.uv_texcoord;
			float temp_output_29_0_g7 = ( _Distortstrength * 0.05 );
			float2 appendResult9_g7 = (float2(-temp_output_29_0_g7 , 0.0));
			float2 appendResult8_g7 = (float2(0.0 , -temp_output_29_0_g7));
			float2 appendResult24_g7 = (float2(tex2D( _Distorttexture, ( UV7_g7 + appendResult9_g7 ) ).r , tex2D( _Distorttexture, ( UV7_g7 + appendResult8_g7 ) ).r));
			float2 appendResult14_g7 = (float2(temp_output_29_0_g7 , 0.0));
			float2 appendResult13_g7 = (float2(0.0 , temp_output_29_0_g7));
			float2 appendResult23_g7 = (float2(tex2D( _Distorttexture, ( UV7_g7 + appendResult14_g7 ) ).r , tex2D( _Distorttexture, ( UV7_g7 + appendResult13_g7 ) ).r));
			float3 appendResult31_g7 = (float3(( ( appendResult24_g7 - appendResult23_g7 ) * _Distortintensity ) , 1.0));
			float3 Distort65 = appendResult31_g7;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 break9 = ase_normWorldNormal;
			float zMask16 = saturate( ( abs( break9.z ) - _AvoidMaskcollision ) );
			float lerpResult48 = lerp( 0.0 , tex2D( _RainMask, ( float3( panner28 ,  0.0 ) + Distort65 ).xy ).r , zMask16);
			float2 appendResult42 = (float2(transform18.z , transform18.y));
			float2 panner44 = ( temp_output_32_0 * _Vector0 + ( _Tiling * appendResult42 ));
			float xMask14 = saturate( ( abs( break9.x ) - _AvoidMaskcollision ) );
			float lerpResult40 = lerp( 0.0 , tex2D( _RainMask, ( Distort65 + float3( panner44 ,  0.0 ) ).xy ).r , xMask14);
			float Streaks25 = saturate( ( lerpResult48 + lerpResult40 ) );
			float yMask15 = saturate( ( break9.y - _AvoidMaskcollision ) );
			float2 temp_cast_5 = (0.37).xx;
			float time101 = ( _Time.y * 1.0 );
			float2 voronoiSmoothId1 = 0;
			float2 coords101 = i.uv_texcoord * _SplochScale;
			float2 id101 = 0;
			float2 uv101 = 0;
			float voroi101 = voronoi101( coords101, time101, id101, uv101, 0, voronoiSmoothId1 );
			float2 VoronoidID129 = id101;
			float Voronoi127 = voroi101;
			float2 panner117 = ( 2.0 * _Time.y * temp_cast_5 + ( VoronoidID129 * step( Voronoi127 , _BigSplochsize ) ));
			float Splashes133 = ( yMask15 * ( tex2D( _RainMask, panner117 ).g * _SplashPower * step( Voronoi127 , _Smallsplochsize ) ) );
			o.Emission = ( _ColorIntensity * ( _Raincolor * ( Streaks25 + Splashes133 ) ) ).rgb;
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
657;73;836;653;658.5332;72.43633;1;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;104;-3872,1568;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-3904,1648;Inherit;False;Constant;_Splochdistortspeed;Sploch distort speed;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;17;-4816,-224;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;102;-3552,1488;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-3680,1568;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-3552,1632;Inherit;False;Property;_SplochScale;Sploch Scale;7;0;Create;True;0;0;0;False;0;False;5.03;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-4432,560;Inherit;False;Property;_Distortstrength;Distort strength;5;0;Create;True;0;0;0;False;0;False;0;0.28;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;7;-2014.484,-256;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-4144,736;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-4144,656;Inherit;False;Property;_Distortintensity;Distort intensity;4;0;Create;True;0;0;0;False;0;False;2;0.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-4144,560;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;18;-4624,-224;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;101;-3312,1536;Inherit;True;2;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.BreakToComponentsNode;9;-1840,-256;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TexturePropertyNode;70;-4147.898,998.4999;Inherit;True;Property;_Distorttexture;Distort texture;6;0;Create;True;0;0;0;False;0;False;None;e9c51e3be909c8a43ae584dbb6db900d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;31;-4112,-128;Inherit;False;Property;_Streakspeed;Streak speed;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;140;-3792,688;Inherit;True;Normal From Height (Working);-1;;7;0721cb0f86921224c90968e737e5cb62;0;4;29;FLOAT;0.001;False;30;FLOAT;0;False;27;FLOAT2;0,0;False;28;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-4176,-384;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1712,-272;Inherit;False;Property;_AvoidMaskcollision;Avoid Mask collision;3;0;Create;True;0;0;0;False;0;False;0.71;0.67;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;24;-4336,-192;Inherit;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;0;False;0;False;0,0;2,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;42;-4252.737,6.157784;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;30;-4112,-192;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;8;-1710.484,-352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;55;-1710.484,-144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-3072,1504;Inherit;False;Voronoi;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-3932.1,-192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-4000,-1.3;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;56;-1344,-144;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;33;-3808,-208;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;110;-2752,992;Inherit;False;Property;_BigSplochsize;Big Sploch size;8;0;Create;True;0;0;0;False;0;False;0.6999048;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-3072,1568;Inherit;False;VoronoidID;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-2992.117,1097.118;Inherit;False;127;Voronoi;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;-1342.484,-352;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-3472,688;Inherit;False;Distort;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-4016,-384;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;44;-3664,-32;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;2,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;66;-1184,-144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;109;-2496,976;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-2496,896;Inherit;False;129;VoronoidID;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;68;-1182.484,-352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-3615,-192;Inherit;False;65;Distort;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;28;-3680,-384;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;2,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;57;-1341.844,-265.0718;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-916,-61;Inherit;True;zMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-2240,896;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-3367.727,-367.9087;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-2240,832;Inherit;False;Constant;_splashLifeTime;splash LifeTime;10;0;Create;True;0;0;0;False;0;False;0.37;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-2764,1216;Inherit;False;Property;_Smallsplochsize;Small sploch size;9;0;Create;True;0;0;0;False;0;False;0.3508353;0.02;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-909.4835,-482;Inherit;True;xMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-3375.567,-29.741;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-3120,-224;Inherit;False;16;zMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;117;-1984,848;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;111;-2496,1200;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-3232,-401;Inherit;True;Property;_RainMask;RainMask;0;0;Create;True;0;0;0;False;0;False;-1;None;ae7f8a9744f0bd54081fff7784394b58;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;67;-1184,-256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-3120,144;Inherit;False;14;xMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-3232,-48;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;40;-2896,-48;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;48;-2896,-336;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;116;-1728,848;Inherit;True;Property;_TextureSample10;Texture Sample 10;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;122;-1712,1056;Inherit;False;Property;_SplashPower;Splash Power;10;0;Create;True;0;0;0;False;0;False;1;0.16;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-912,-272;Inherit;True;yMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;152;-1509.86,1198.185;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-1392,864;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;-1392,784;Inherit;False;15;yMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-2672,-208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-1152,864;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;54;-2544,-208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-944,864;Inherit;False;Splashes;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-2400,-208;Inherit;False;Streaks;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-864,192;Inherit;False;25;Streaks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-864,272;Inherit;False;133;Splashes;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;141;-656,32;Inherit;False;Property;_Raincolor;Rain color;11;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.7358491,0.779989,0.9811321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;134;-656,208;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-416,48;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-480,-32;Inherit;False;Property;_ColorIntensity;Color Intensity;12;0;Create;True;0;0;0;False;0;False;0;1.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;156;-320,384;Inherit;False;14;xMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-320,304;Inherit;False;16;zMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;157;-128,352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-272,48;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Final/Rain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;150;0;104;0
WireConnection;150;1;107;0
WireConnection;74;0;62;0
WireConnection;18;0;17;0
WireConnection;101;0;102;0
WireConnection;101;1;150;0
WireConnection;101;2;103;0
WireConnection;9;0;7;0
WireConnection;140;29;74;0
WireConnection;140;30;61;0
WireConnection;140;27;58;0
WireConnection;140;28;70;0
WireConnection;19;0;18;1
WireConnection;19;1;18;2
WireConnection;42;0;18;3
WireConnection;42;1;18;2
WireConnection;8;0;9;0
WireConnection;55;0;9;2
WireConnection;127;0;101;0
WireConnection;32;0;30;0
WireConnection;32;1;31;0
WireConnection;43;0;24;0
WireConnection;43;1;42;0
WireConnection;56;0;55;0
WireConnection;56;1;53;0
WireConnection;129;0;101;1
WireConnection;52;0;8;0
WireConnection;52;1;53;0
WireConnection;65;0;140;0
WireConnection;20;0;19;0
WireConnection;20;1;24;0
WireConnection;44;0;43;0
WireConnection;44;2;33;0
WireConnection;44;1;32;0
WireConnection;66;0;56;0
WireConnection;109;0;128;0
WireConnection;109;1;110;0
WireConnection;68;0;52;0
WireConnection;28;0;20;0
WireConnection;28;2;33;0
WireConnection;28;1;32;0
WireConnection;57;0;9;1
WireConnection;57;1;53;0
WireConnection;16;0;66;0
WireConnection;115;0;130;0
WireConnection;115;1;109;0
WireConnection;75;0;28;0
WireConnection;75;1;77;0
WireConnection;14;0;68;0
WireConnection;76;0;77;0
WireConnection;76;1;44;0
WireConnection;117;0;115;0
WireConnection;117;2;118;0
WireConnection;111;0;128;0
WireConnection;111;1;112;0
WireConnection;1;1;75;0
WireConnection;67;0;57;0
WireConnection;45;1;76;0
WireConnection;40;1;45;1
WireConnection;40;2;50;0
WireConnection;48;1;1;1
WireConnection;48;2;51;0
WireConnection;116;1;117;0
WireConnection;15;0;67;0
WireConnection;152;0;111;0
WireConnection;119;0;116;2
WireConnection;119;1;122;0
WireConnection;119;2;152;0
WireConnection;49;0;48;0
WireConnection;49;1;40;0
WireConnection;131;0;132;0
WireConnection;131;1;119;0
WireConnection;54;0;49;0
WireConnection;133;0;131;0
WireConnection;25;0;54;0
WireConnection;134;0;27;0
WireConnection;134;1;135;0
WireConnection;142;0;141;0
WireConnection;142;1;134;0
WireConnection;157;0;155;0
WireConnection;157;1;156;0
WireConnection;144;0;143;0
WireConnection;144;1;142;0
WireConnection;0;2;144;0
ASEEND*/
//CHKSM=AAF233183E666FC94054C06F318144DB6D2C8258