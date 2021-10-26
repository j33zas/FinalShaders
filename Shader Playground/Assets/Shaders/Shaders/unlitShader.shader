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
		[IntRange]_Direction("Direction", Range( -1 , 1)) = 0
		[IntRange]_EdgeDirection("Edge Direction", Range( -1 , 1)) = 0
		_EdgeSize("Edge Size", Range( 0.4 , 1)) = 0
		[Toggle(_EDGENOISE_ON)] _Edgenoise("Edge noise", Float) = 0
		_NoiseMaskStep("Noise Mask Step", Range( 0 , 1)) = 0.3
		_EdgenoiseTiling("Edge noise Tiling", Vector) = (6,3,0,0)
		_EdgeColor("Edge Color", Color) = (0.174191,0.5283019,0,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#pragma shader_feature _EDGENOISE_ON
			#pragma shader_feature _USECOLORSTEP_ON


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _Size;
			uniform float _EdgeSize;
			uniform float _NoiseMaskStep;
			uniform sampler2D _Noise;
			uniform float _EdgeDirection;
			uniform float2 _EdgenoiseTiling;
			uniform float4 _ColorA;
			uniform float4 _ColorB;
			uniform float _Direction;
			uniform float _ColorStep;
			uniform float4 _EdgeColor;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( _Size * 0.00627 ) * ( v.ase_normal * float3(1,1,0) ) );
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord32 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord55 = i.ase_texcoord1.xy * _EdgenoiseTiling + float2( 0,0 );
				float2 panner64 = ( _Time.y * ( float2( 1,0 ) * _EdgeDirection ) + texCoord55);
				#ifdef _EDGENOISE_ON
				float staticSwitch54 = step( _NoiseMaskStep , ( pow( texCoord32.y , 15.0 ) * tex2D( _Noise, panner64 ).r ) );
				#else
				float staticSwitch54 = saturate( step( _EdgeSize , texCoord32.y ) );
				#endif
				float EdgeMask42 = staticSwitch54;
				float2 temp_cast_0 = (3.0).xx;
				float2 texCoord22 = i.ase_texcoord1.xy * temp_cast_0 + float2( 0,0 );
				float2 panner21 = ( _Time.y * ( float2( 1,0 ) * _Direction ) + texCoord22);
				float4 tex2DNode18 = tex2D( _Noise, panner21 );
				#ifdef _USECOLORSTEP_ON
				float staticSwitch26 = step( tex2DNode18.r , _ColorStep );
				#else
				float staticSwitch26 = tex2DNode18.r;
				#endif
				float NoiseMask27 = staticSwitch26;
				float4 lerpResult17 = lerp( _ColorA , _ColorB , NoiseMask27);
				
				
				finalColor = ( ( ( 1.0 - EdgeMask42 ) * lerpResult17 ) + ( EdgeMask42 * _EdgeColor ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18912
435;73;1087;515;3723.607;613.7408;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;70;-3519.865,-1634.953;Inherit;False;2101.002;775.0004;Comment;20;68;69;56;65;55;50;32;64;51;48;41;40;47;39;52;54;42;53;66;67;Edge mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;29;-3294.92,-570.7072;Inherit;False;1551.92;437;Comment;13;22;25;23;24;21;18;20;26;19;27;30;31;71;Color Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-3469.865,-974.9529;Inherit;False;Constant;_Edgespeed;Edge speed;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;56;-3469.865,-1326.953;Inherit;False;Property;_EdgenoiseTiling;Edge noise Tiling;11;0;Create;True;0;0;0;False;0;False;6,3;6,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;69;-3469.865,-1198.953;Inherit;False;Constant;_Vector2;Vector 2;5;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;68;-3469.865,-1070.953;Inherit;False;Property;_EdgeDirection;Edge Direction;7;1;[IntRange];Create;True;0;0;0;False;0;False;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;66;-3293.865,-974.9529;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-3197.865,-1198.953;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-3280,-528;Inherit;False;Constant;_NoiseTile;Noise Tile;13;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-3245.865,-1326.953;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;23;-3280,-464;Inherit;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;31;-3280,-352;Inherit;False;Property;_Direction;Direction;6;1;[IntRange];Create;True;0;0;0;False;0;False;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-3244.92,-280.7072;Inherit;False;Constant;_Colorspeed;Color speed;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-2813.865,-1504.953;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;64;-2960,-1168;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2813.865,-1264.953;Inherit;False;Constant;_Edgemasksize;Edge mask size;8;0;Create;True;0;0;0;False;0;False;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2992,-416;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;24;-3052.92,-280.7072;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-3052.92,-520.7072;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;21;-2796.92,-440.7072;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;48;-2765.865,-1168.953;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;18;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;51;-2605.865,-1280.953;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2813.865,-1584.953;Inherit;False;Property;_EdgeSize;Edge Size;8;0;Create;True;0;0;0;False;0;False;0;0.7348139;0.4;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-2620.92,-440.7072;Inherit;True;Property;_Noise;Noise;3;0;Create;True;0;0;0;False;0;False;-1;None;e9c51e3be909c8a43ae584dbb6db900d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-2445.865,-1056.953;Inherit;False;Property;_NoiseMaskStep;Noise Mask Step;10;0;Create;True;0;0;0;False;0;False;0.3;0.01764706;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2620.92,-248.7072;Inherit;False;Property;_ColorStep;Color Step;4;0;Create;True;0;0;0;False;0;False;0.07450778;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;40;-2508.799,-1512.653;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-2445.865,-1280.953;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-2396.799,-1511.353;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;19;-2316.92,-376.7072;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;52;-2141.865,-1280.953;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;26;-2188.919,-440.7072;Inherit;False;Property;_UseColorStep;Use Color Step;5;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;54;-1901.865,-1504.953;Inherit;False;Property;_Edgenoise;Edge noise;9;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-1661.863,-1504.953;Inherit;False;EdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1952,-448;Inherit;False;NoiseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-1267.444,-590.1575;Inherit;False;Property;_ColorA;Color A;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.1254902,0.3958011,0.7529412,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1264,-176;Inherit;False;42;EdgeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1267.444,-430.1575;Inherit;False;Property;_ColorB;Color B;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.754717,0.1245995,0.1245995,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1264,-256;Inherit;False;27;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-928,-448;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;63;-928,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1036,106;Inherit;False;Constant;_Control;Control;2;0;Create;True;0;0;0;False;0;False;0.00627;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1034,41;Inherit;False;Property;_Size;Size;2;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;6;-1040,176;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;15;-1040,304;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;1,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;58;-1264,-96;Inherit;False;Property;_EdgeColor;Edge Color;12;0;Create;True;0;0;0;False;0;False;0.174191,0.5283019,0,0;0.174191,0.5283019,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-752,-272;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-928,-192;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-784,176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-780,42;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-592,48;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-592,-272;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;True;-1;2;ASEMaterialInspector;100;1;Final/Spinner;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;66;0;67;0
WireConnection;65;0;69;0
WireConnection;65;1;68;0
WireConnection;55;0;56;0
WireConnection;64;0;55;0
WireConnection;64;2;65;0
WireConnection;64;1;66;0
WireConnection;30;0;23;0
WireConnection;30;1;31;0
WireConnection;24;0;25;0
WireConnection;22;0;71;0
WireConnection;21;0;22;0
WireConnection;21;2;30;0
WireConnection;21;1;24;0
WireConnection;48;1;64;0
WireConnection;51;0;32;2
WireConnection;51;1;50;0
WireConnection;18;1;21;0
WireConnection;40;0;41;0
WireConnection;40;1;32;2
WireConnection;47;0;51;0
WireConnection;47;1;48;1
WireConnection;39;0;40;0
WireConnection;19;0;18;1
WireConnection;19;1;20;0
WireConnection;52;0;53;0
WireConnection;52;1;47;0
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
WireConnection;57;0;45;0
WireConnection;57;1;58;0
WireConnection;14;0;6;0
WireConnection;14;1;15;0
WireConnection;11;0;4;0
WireConnection;11;1;12;0
WireConnection;7;0;11;0
WireConnection;7;1;14;0
WireConnection;59;0;62;0
WireConnection;59;1;57;0
WireConnection;1;0;59;0
WireConnection;1;1;7;0
ASEEND*/
//CHKSM=53E6BB0679975B00507976A9CE38262DF8423C80