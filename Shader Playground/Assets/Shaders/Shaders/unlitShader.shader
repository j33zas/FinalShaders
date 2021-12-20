// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Final/Spinner"
{
	Properties
	{
		_ColorB("Color B", Color) = (1,1,1,0)
		_ColorA("Color A", Color) = (1,1,1,0)
		_Size("Size", Range( 0 , 1)) = 0
		_Noise("Noise", 2D) = "white" {}
		_ColorStep("Color Step", Range( 0 , 1)) = 0.07450778
		[Toggle(_USECOLORSTEP_ON)] _UseColorStep("Use Color Step", Float) = 0
		_Colorspeed("Color speed", Float) = 1
		_Edgespeed("Edge speed", Float) = 1
		[IntRange]_Direction("Direction", Range( -1 , 1)) = 0
		[IntRange]_EdgeDirection("Edge Direction", Range( -1 , 1)) = 0
		_EdgeSize("Edge Size", Range( 0.4 , 1)) = 0
		[Toggle(_EDGENOISE_ON)] _Edgenoise("Edge noise", Float) = 0
		_NoiseMaskStep("Noise Mask Step", Range( 0 , 1)) = 0.3
		_EdgenoiseTiling("Edge noise Tiling", Vector) = (6,3,0,0)
		_EdgeColor("Edge Color", Color) = (0.174191,0.5283019,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma shader_feature _EDGENOISE_ON
		#pragma shader_feature _USECOLORSTEP_ON
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Size;
		uniform float _EdgeSize;
		uniform float _NoiseMaskStep;
		uniform sampler2D _Noise;
		uniform float _Edgespeed;
		uniform float _EdgeDirection;
		uniform float2 _EdgenoiseTiling;
		uniform float4 _ColorA;
		uniform float4 _ColorB;
		uniform float _Colorspeed;
		uniform float _Direction;
		uniform float _ColorStep;
		uniform float4 _EdgeColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( _Size * 0.00627 ) * ( ase_vertexNormal * float3(1,1,0) ) );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime66 = _Time.y * _Edgespeed;
			float2 uv_TexCoord55 = i.uv_texcoord * _EdgenoiseTiling;
			float2 panner64 = ( mulTime66 * ( float2( 1,0 ) * _EdgeDirection ) + uv_TexCoord55);
			#ifdef _EDGENOISE_ON
				float staticSwitch54 = step( ( _NoiseMaskStep * 0.1 ) , ( pow( i.uv_texcoord.y , 15.0 ) * tex2D( _Noise, panner64 ).r ) );
			#else
				float staticSwitch54 = saturate( step( _EdgeSize , i.uv_texcoord.y ) );
			#endif
			float EdgeMask42 = staticSwitch54;
			float mulTime24 = _Time.y * _Colorspeed;
			float2 temp_cast_0 = (3.0).xx;
			float2 uv_TexCoord22 = i.uv_texcoord * temp_cast_0;
			float2 panner21 = ( mulTime24 * ( float2( 1,0 ) * _Direction ) + uv_TexCoord22);
			float4 tex2DNode18 = tex2D( _Noise, panner21 );
			#ifdef _USECOLORSTEP_ON
				float staticSwitch26 = step( tex2DNode18.r , _ColorStep );
			#else
				float staticSwitch26 = tex2DNode18.r;
			#endif
			float NoiseMask27 = staticSwitch26;
			float4 lerpResult17 = lerp( _ColorA , _ColorB , NoiseMask27);
			o.Emission = ( ( ( 1.0 - EdgeMask42 ) * lerpResult17 ) + ( EdgeMask42 * _EdgeColor ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
30;414;947;590;4041.182;707.4533;1.379103;True;False
Node;AmplifyShaderEditor.CommentaryNode;70;-3519.865,-1634.953;Inherit;False;2101.002;775.0004;Comment;21;68;69;56;65;55;50;32;64;51;48;41;40;47;39;52;54;42;53;66;67;73;Edge mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-3469.865,-1070.953;Inherit;False;Property;_EdgeDirection;Edge Direction;9;1;[IntRange];Create;True;0;0;0;False;0;False;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;69;-3469.865,-1198.953;Inherit;False;Constant;_Vector2;Vector 2;5;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;67;-3469.865,-974.9529;Inherit;False;Property;_Edgespeed;Edge speed;7;0;Create;True;0;0;0;False;0;False;1;8.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;29;-3294.92,-570.7072;Inherit;False;1551.92;437;Comment;13;22;25;23;24;21;18;20;26;19;27;30;31;71;Color Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;56;-3469.865,-1326.953;Inherit;False;Property;_EdgenoiseTiling;Edge noise Tiling;13;0;Create;True;0;0;0;False;0;False;6,3;6,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;31;-3280,-352;Inherit;False;Property;_Direction;Direction;8;1;[IntRange];Create;True;0;0;0;False;0;False;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;23;-3280,-464;Inherit;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-3245.865,-1326.953;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-3244.92,-280.7072;Inherit;False;Property;_Colorspeed;Color speed;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-3197.865,-1198.953;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;66;-3293.865,-974.9529;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-3280,-528;Inherit;False;Constant;_NoiseTile;Noise Tile;13;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-3052.92,-520.7072;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;24;-3052.92,-280.7072;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2813.865,-1264.953;Inherit;False;Constant;_Edgemasksize;Edge mask size;8;0;Create;True;0;0;0;False;0;False;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;64;-2960,-1168;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-2813.865,-1504.953;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2992,-416;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2740.865,-981.953;Inherit;False;Property;_NoiseMaskStep;Noise Mask Step;12;0;Create;True;0;0;0;False;0;False;0.3;0.3660302;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-2796.92,-440.7072;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;48;-2765.865,-1168.953;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;18;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;51;-2605.865,-1280.953;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2813.865,-1584.953;Inherit;False;Property;_EdgeSize;Edge Size;10;0;Create;True;0;0;0;False;0;False;0;0.4;0.4;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2620.92,-248.7072;Inherit;False;Property;_ColorStep;Color Step;4;0;Create;True;0;0;0;False;0;False;0.07450778;0.356;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-2445.865,-1280.953;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-2620.92,-440.7072;Inherit;True;Property;_Noise;Noise;3;0;Create;True;0;0;0;False;0;False;-1;None;e9c51e3be909c8a43ae584dbb6db900d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-2412.555,-1007.409;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;40;-2508.799,-1512.653;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;52;-2141.865,-1280.953;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-2396.799,-1511.353;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;19;-2316.92,-376.7072;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;26;-2188.919,-440.7072;Inherit;False;Property;_UseColorStep;Use Color Step;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;54;-1901.865,-1504.953;Inherit;False;Property;_Edgenoise;Edge noise;11;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-1661.863,-1504.953;Inherit;False;EdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1952,-448;Inherit;False;NoiseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-1267.444,-590.1575;Inherit;False;Property;_ColorA;Color A;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.1254902,0.3958011,0.7529412,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1264,-256;Inherit;False;27;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1267.444,-430.1575;Inherit;False;Property;_ColorB;Color B;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.754717,0.1245995,0.1245995,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1264,-176;Inherit;False;42;EdgeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;58;-1264,-96;Inherit;False;Property;_EdgeColor;Edge Color;14;0;Create;True;0;0;0;False;0;False;0.174191,0.5283019,0,0;0.2099056,0.4245283,0.1061321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;15;-1040,304;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;1,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-1034,41;Inherit;False;Property;_Size;Size;2;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1036,106;Inherit;False;Constant;_Control;Control;2;0;Create;True;0;0;0;False;0;False;0.00627;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-928,-448;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;63;-928,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;6;-1040,176;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-752,-272;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-784,176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-780,42;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-928,-192;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-592,48;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-592,-272;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;72;-222.0941,-249.5706;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;Final/Spinner;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;55;0;56;0
WireConnection;65;0;69;0
WireConnection;65;1;68;0
WireConnection;66;0;67;0
WireConnection;22;0;71;0
WireConnection;24;0;25;0
WireConnection;64;0;55;0
WireConnection;64;2;65;0
WireConnection;64;1;66;0
WireConnection;30;0;23;0
WireConnection;30;1;31;0
WireConnection;21;0;22;0
WireConnection;21;2;30;0
WireConnection;21;1;24;0
WireConnection;48;1;64;0
WireConnection;51;0;32;2
WireConnection;51;1;50;0
WireConnection;47;0;51;0
WireConnection;47;1;48;1
WireConnection;18;1;21;0
WireConnection;73;0;53;0
WireConnection;40;0;41;0
WireConnection;40;1;32;2
WireConnection;52;0;73;0
WireConnection;52;1;47;0
WireConnection;39;0;40;0
WireConnection;19;0;18;1
WireConnection;19;1;20;0
WireConnection;26;1;18;1
WireConnection;26;0;19;0
WireConnection;54;1;39;0
WireConnection;54;0;52;0
WireConnection;42;0;54;0
WireConnection;27;0;26;0
WireConnection;17;0;16;0
WireConnection;17;1;2;0
WireConnection;17;2;28;0
WireConnection;63;0;45;0
WireConnection;62;0;63;0
WireConnection;62;1;17;0
WireConnection;14;0;6;0
WireConnection;14;1;15;0
WireConnection;11;0;4;0
WireConnection;11;1;12;0
WireConnection;57;0;45;0
WireConnection;57;1;58;0
WireConnection;7;0;11;0
WireConnection;7;1;14;0
WireConnection;59;0;62;0
WireConnection;59;1;57;0
WireConnection;72;2;59;0
WireConnection;72;11;7;0
ASEEND*/
//CHKSM=A559009849C73A088F6906878030D395393C63AB