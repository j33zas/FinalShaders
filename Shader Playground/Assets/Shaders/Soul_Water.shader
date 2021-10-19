// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Final/SoulWater"
{
	Properties
	{
		_FlowSpeed("Flow Speed", Float) = 1
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 50
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.671
		_WaveIntensity("Wave Intensity", Range( 0 , 1)) = 0.4348507
		_Direction("Direction", Vector) = (0,1,0,0)
		_try1("try 1", 2D) = "white" {}
		_Opacity("Opacity", Range( -1 , 10)) = 0
		_Opacityadd("Opacity add", Range( 0 , 1)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "bump" {}
		_GenericClouds("GenericClouds", 2D) = "white" {}
		_WaveHeight("Wave Height", Range( 0 , 2)) = 0.11
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _GenericClouds;
		uniform float _FlowSpeed;
		uniform float2 _Direction;
		uniform float _WaveHeight;
		uniform sampler2D _try1;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _WaveIntensity;
		uniform float _Opacityadd;
		uniform float _Opacity;
		uniform float _EdgeLength;
		uniform float _TessPhongStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime9 = _Time.y * _FlowSpeed;
			float2 panner7 = ( mulTime9 * _Direction + float2( 0,0 ));
			float2 uv_TexCoord26 = v.texcoord.xy + panner7;
			float4 tex2DNode21 = tex2Dlod( _GenericClouds, float4( uv_TexCoord26, 0, 0.0) );
			v.vertex.xyz += saturate( ( tex2DNode21.r * _WaveHeight * float3(0,1,0) ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float mulTime9 = _Time.y * _FlowSpeed;
			float2 panner7 = ( mulTime9 * _Direction + float2( 0,0 ));
			float2 uv_TexCoord8 = i.uv_texcoord + panner7;
			float4 tex2DNode15 = tex2D( _try1, ( ( (UnpackNormal( tex2D( _TextureSample0, uv_TextureSample0 ) )).xy * _WaveIntensity ) + uv_TexCoord8 ) );
			o.Albedo = tex2DNode15.rgb;
			float2 uv_TexCoord26 = i.uv_texcoord + panner7;
			float4 tex2DNode21 = tex2D( _GenericClouds, uv_TexCoord26 );
			o.Alpha = saturate( ( _Opacityadd + ( tex2DNode15.r * _Opacity * tex2DNode21.r ) ) );
		}

		ENDCG
		CGPROGRAM
		#pragma exclude_renderers switch nomrt 
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
651;73;842;653;2791.791;-168.5597;1.106518;True;False
Node;AmplifyShaderEditor.RangedFloatNode;10;-3449.072,111.7613;Float;False;Property;_FlowSpeed;Flow Speed;0;0;Create;True;0;0;0;False;0;False;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;11;-3241.072,-16.2387;Float;False;Property;_Direction;Direction;7;0;Create;True;0;0;0;False;0;False;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;9;-3241.072,111.7613;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-3579.089,-295.9279;Inherit;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;0;0;0;False;0;False;-1;None;b3433f332373fcf44b5636488fa65cea;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;7;-3022.015,-32.76044;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-3065.072,-208.2387;Float;False;Property;_WaveIntensity;Wave Intensity;6;0;Create;True;0;0;0;False;0;False;0.4348507;0.4685225;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;18;-3001.072,-288.2387;Inherit;False;True;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2729.072,-224.2387;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2816.598,-70.74258;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-2793.072,191.7613;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-2544.933,-134.3725;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;15;-2373.105,-173.1329;Inherit;True;Property;_try1;try 1;8;0;Create;True;0;0;0;False;0;False;-1;d05d48605a8f09546b048f4ba15c5247;d05d48605a8f09546b048f4ba15c5247;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-2377.074,158.7613;Inherit;True;Property;_GenericClouds;GenericClouds;12;0;Create;True;0;0;0;False;0;False;-1;e9c51e3be909c8a43ae584dbb6db900d;e9c51e3be909c8a43ae584dbb6db900d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-2368,48;Float;False;Property;_Opacity;Opacity;9;0;Create;True;0;0;0;False;0;False;0;4.494118;-1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2361.075,367.7613;Float;False;Property;_WaveHeight;Wave Height;13;0;Create;True;0;0;0;False;0;False;0.11;0.6352941;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;30;-2265.075,463.7613;Float;False;Constant;_Vector2;Vector 2;7;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1993.771,24.18181;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2000,-48;Float;False;Property;_Opacityadd;Opacity add;10;0;Create;True;0;0;0;False;0;False;0;0.6235294;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-1664,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-2025.079,159.7613;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;44;-1536,0;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;29;-1888,160;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-660.3207,-144.0061;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Final/SoulWater;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;50;10;25;True;0.671;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;10;0
WireConnection;7;2;11;0
WireConnection;7;1;9;0
WireConnection;18;0;17;0
WireConnection;19;0;18;0
WireConnection;19;1;20;0
WireConnection;8;1;7;0
WireConnection;26;1;7;0
WireConnection;16;0;19;0
WireConnection;16;1;8;0
WireConnection;15;1;16;0
WireConnection;21;1;26;0
WireConnection;47;0;15;1
WireConnection;47;1;41;0
WireConnection;47;2;21;1
WireConnection;48;0;49;0
WireConnection;48;1;47;0
WireConnection;31;0;21;1
WireConnection;31;1;32;0
WireConnection;31;2;30;0
WireConnection;44;0;48;0
WireConnection;29;0;31;0
WireConnection;0;0;15;0
WireConnection;0;9;44;0
WireConnection;0;11;29;0
ASEEND*/
//CHKSM=9D67149DB385D3E65528CF46E2F1C9FF05155BDF