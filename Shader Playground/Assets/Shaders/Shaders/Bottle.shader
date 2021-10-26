// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Final/Bottle"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_LiquidFill("Liquid Fill", Range( 0 , 1)) = 0
		[HDR]_LiquidColor("Liquid Color", Color) = (0.2924528,0.1215394,0.1034621,0)
		_Bubbles("Bubbles", 2D) = "white" {}
		_Distortintensity("Distort intensity", Float) = 2
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Distortstrength("Distort strength", Range( 0 , 1)) = 0
		_Distorttexture("Distort texture", 2D) = "white" {}
		_BubbleSpeed("Bubble Speed", Float) = 1
		_MaskSub("MaskSub", Float) = 0
		_BubbleSize("Bubble Size", Range( 0 , 1)) = 0
		_BubbleColor("Bubble  Color", Color) = (0.4510947,0.8773585,0.8301893,0)
		_BubbleStrength("Bubble Strength", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float4 _LiquidColor;
		uniform float4 _BubbleColor;
		uniform float _BubbleSize;
		uniform sampler2D _Bubbles;
		uniform float _BubbleSpeed;
		uniform sampler2D _Distorttexture;
		uniform float _Distortstrength;
		uniform float _Distortintensity;
		uniform float _MaskSub;
		uniform sampler2D _TextureSample0;
		uniform float _BubbleStrength;
		uniform float _LiquidFill;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV189 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode189 = ( 0.0 + 1.69 * pow( 1.0 - fresnelNdotV189, 1.83 ) );
			float temp_output_193_0 = ( 1.0 - fresnelNode189 );
			float mulTime68 = _Time.y * _BubbleSpeed;
			float BubbleSpeed156 = mulTime68;
			float2 _Vector2 = float2(0,-1);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform74 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float2 appendResult82 = (float2(transform74.x , transform74.y));
			float2 panner39 = ( BubbleSpeed156 * _Vector2 + appendResult82);
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
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 break125 = ase_normWorldNormal;
			float zMask150 = saturate( ( _MaskSub - ( 1.0 - abs( break125.z ) ) ) );
			float lerpResult86 = lerp( 0.0 , tex2D( _Bubbles, ( float3( panner39 ,  0.0 ) + Distort65 ).xy ).r , zMask150);
			float4 transform134 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float2 appendResult136 = (float2(transform134.z , transform134.y));
			float2 panner137 = ( BubbleSpeed156 * _Vector2 + appendResult136);
			float xMask128 = saturate( ( abs( break125.x ) - _MaskSub ) );
			float lerpResult141 = lerp( 0.0 , tex2D( _TextureSample0, ( Distort65 + float3( panner137 ,  0.0 ) ).xy ).r , xMask128);
			float BubblesMask110 = step( _BubbleSize , ( lerpResult86 + lerpResult141 ) );
			o.Emission = saturate( ( ( _LiquidColor * temp_output_193_0 ) + ( _BubbleColor * BubblesMask110 * _BubbleStrength * temp_output_193_0 ) ) ).rgb;
			o.Alpha = 1;
			float OpacityMask32 = saturate( step( ( 1.0 - ( ase_vertex3Pos - ase_worldPos ).y ) , ( _LiquidFill * 5.3 ) ) );
			clip( OpacityMask32 - _Cutoff );
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
303;73;1190;653;1390.437;40.51083;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;113;-2912,-1072;Inherit;False;1377.975;348;Comment;16;155;122;120;152;128;150;149;153;162;124;125;123;180;181;182;183;ZXMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;123;-2880,-944;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;168;-2912,-2256;Inherit;False;1253;712;Comment;7;59;63;61;62;60;64;65;Distort Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-3632,-1456;Inherit;False;Property;_BubbleSpeed;Bubble Speed;7;0;Create;True;0;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-2864,-2208;Inherit;False;Property;_Distortstrength;Distort strength;5;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;125;-2704,-944;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;169;-5152,-1344;Inherit;False;2203.903;623;Comment;24;75;135;74;134;158;136;85;82;157;137;67;39;66;139;108;140;151;38;86;141;167;143;166;110;BubbleMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2576,-2112;Inherit;False;Property;_Distortintensity;Distort intensity;4;0;Create;True;0;0;0;False;0;False;2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;75;-5088,-1280;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;124;-2512,-816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;135;-5104,-992;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-2576,-2208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;68;-3440,-1456;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-2576,-2032;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;60;-2592,-1776;Inherit;True;Property;_Distorttexture;Distort texture;6;0;Create;True;0;0;0;False;0;False;None;e9c51e3be909c8a43ae584dbb6db900d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.AbsOpNode;122;-2512,-1008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;134;-4912,-992;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;162;-2400,-816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;64;-2224,-2080;Inherit;True;Normal From Height (Working);-1;;7;0721cb0f86921224c90968e737e5cb62;0;4;29;FLOAT;0.001;False;30;FLOAT;0;False;27;FLOAT2;0,0;False;28;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-3264,-1456;Inherit;False;BubbleSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-2544,-896;Inherit;False;Property;_MaskSub;MaskSub;8;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;74;-4896,-1280;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;85;-4720,-1104;Inherit;False;Constant;_Vector2;Vector 2;10;0;Create;True;0;0;0;False;0;False;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;157;-4912,-1120;Inherit;False;156;BubbleSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;152;-2192,-1008;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;153;-2192,-832;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1904,-2080;Inherit;False;Distort;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;136;-4720,-992;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;-4912,-832;Inherit;False;156;BubbleSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;-4704,-1280;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-4512,-1088;Inherit;False;65;Distort;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;120;-2032,-1008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;39;-4528,-1264;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;149;-2016,-832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;137;-4512,-944;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;139;-4304,-944;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;150;-1872,-832;Inherit;False;zMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-4304,-1264;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-1872,-1008;Inherit;False;xMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;151;-4064,-1040;Inherit;False;128;xMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;140;-4176,-976;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;106a0276f3c12d84d90e915934517fad;106a0276f3c12d84d90e915934517fad;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;112;-2912,-1520;Inherit;False;1324.601;427.0001;Comment;11;31;25;26;30;28;32;29;24;23;13;22;Opacity Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;38;-4176,-1296;Inherit;True;Property;_Bubbles;Bubbles;3;0;Create;True;0;0;0;False;0;False;-1;106a0276f3c12d84d90e915934517fad;106a0276f3c12d84d90e915934517fad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;108;-4064,-1120;Inherit;False;150;zMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;86;-3872,-1280;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;22;-2864,-1280;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;141;-3856,-976;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;13;-2864,-1472;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;143;-3600,-1104;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-3600,-992;Inherit;False;Property;_BubbleSize;Bubble Size;9;0;Create;True;0;0;0;False;0;False;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-2576,-1344;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;166;-3296,-1104;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;24;-2432,-1344;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;28;-2599,-1233;Inherit;False;Property;_LiquidFill;Liquid Fill;1;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2336,-1232;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;5.3;5.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;189;-1110,42;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.69;False;3;FLOAT;1.83;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2192,-1248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-3136,-1088;Inherit;False;BubblesMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;29;-2320,-1328;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;193;-880,32;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-1136,256;Inherit;False;Property;_BubbleStrength;Bubble Strength;11;0;Create;True;0;0;0;False;0;False;1;0.846;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-1102.444,503.7484;Inherit;False;110;BubblesMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;25;-2064,-1328;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;170;-1118.444,343.7485;Inherit;False;Property;_BubbleColor;Bubble  Color;10;0;Create;True;0;0;0;False;0;False;0.4510947,0.8773585,0.8301893,0;0.5919186,0.6415094,0.5719117,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;35;-1104,-128;Inherit;False;Property;_LiquidColor;Liquid Color;2;1;[HDR];Create;True;0;0;0;False;0;False;0.2924528,0.1215394,0.1034621,0;0.09433961,0.04377164,0.03871484,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;31;-1952,-1328;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-736,-80;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-864,352;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1808,-1328;Inherit;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;-525.9787,-52.56651;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;182;-2032,-928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;180;-2384,-912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;-308,218;Inherit;False;32;OpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-1856,-929;Inherit;False;yMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;181;-2208,-928;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;177;-224,16;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-12,15;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Final/Bottle;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;125;0;123;0
WireConnection;124;0;125;2
WireConnection;61;0;59;0
WireConnection;68;0;69;0
WireConnection;122;0;125;0
WireConnection;134;0;135;0
WireConnection;162;0;124;0
WireConnection;64;29;61;0
WireConnection;64;30;62;0
WireConnection;64;27;63;0
WireConnection;64;28;60;0
WireConnection;156;0;68;0
WireConnection;74;0;75;0
WireConnection;152;0;122;0
WireConnection;152;1;155;0
WireConnection;153;0;155;0
WireConnection;153;1;162;0
WireConnection;65;0;64;0
WireConnection;136;0;134;3
WireConnection;136;1;134;2
WireConnection;82;0;74;1
WireConnection;82;1;74;2
WireConnection;120;0;152;0
WireConnection;39;0;82;0
WireConnection;39;2;85;0
WireConnection;39;1;157;0
WireConnection;149;0;153;0
WireConnection;137;0;136;0
WireConnection;137;2;85;0
WireConnection;137;1;158;0
WireConnection;139;0;67;0
WireConnection;139;1;137;0
WireConnection;150;0;149;0
WireConnection;66;0;39;0
WireConnection;66;1;67;0
WireConnection;128;0;120;0
WireConnection;140;1;139;0
WireConnection;38;1;66;0
WireConnection;86;1;38;1
WireConnection;86;2;108;0
WireConnection;141;1;140;1
WireConnection;141;2;151;0
WireConnection;143;0;86;0
WireConnection;143;1;141;0
WireConnection;23;0;13;0
WireConnection;23;1;22;0
WireConnection;166;0;167;0
WireConnection;166;1;143;0
WireConnection;24;0;23;0
WireConnection;30;0;28;0
WireConnection;30;1;26;0
WireConnection;110;0;166;0
WireConnection;29;0;24;1
WireConnection;193;0;189;0
WireConnection;25;0;29;0
WireConnection;25;1;30;0
WireConnection;31;0;25;0
WireConnection;194;0;35;0
WireConnection;194;1;193;0
WireConnection;174;0;170;0
WireConnection;174;1;172;0
WireConnection;174;2;179;0
WireConnection;174;3;193;0
WireConnection;32;0;31;0
WireConnection;176;0;194;0
WireConnection;176;1;174;0
WireConnection;182;0;181;0
WireConnection;180;0;125;1
WireConnection;183;0;182;0
WireConnection;181;0;180;0
WireConnection;181;1;155;0
WireConnection;177;0;176;0
WireConnection;0;2;177;0
WireConnection;0;10;173;0
ASEEND*/
//CHKSM=9A3385FD1E4FBC7E93CFD25C6515D9A7E5E5A048