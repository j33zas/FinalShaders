// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Final/pp/cracked"
{
	Properties
	{
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_SCREEN_POSITION_NORMALIZED

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			

			
			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 uv_MainTex = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float mulTime209 = _Time.y * 4.0;
				float2 appendResult136 = (float2(ase_ppsScreenPosFragNorm.x , ase_ppsScreenPosFragNorm.y));
				float2 appendResult147 = (float2(0.5 , 0.5));
				float EdgeMask241 = saturate( ( pow( distance( appendResult136 , appendResult147 ) , 5.0 ) * 7.29 ) );
				float SinEdgeMask272 = ( ( ( sin( mulTime209 ) + 1.0 ) / 3.25 ) * EdgeMask241 );
				float4 color304 = IsGammaSpace() ? float4(0,0.9582813,1,0) : float4(0,0.907708,1,0);
				float4 color305 = IsGammaSpace() ? float4(0.07069919,0,0.3679245,0) : float4(0.006061667,0,0.1114872,0);
				float2 temp_cast_0 = (10.0).xx;
				float2 texCoord159 = i.texcoord.xy * temp_cast_0 + float2( 0.5,0.5 );
				float2 temp_output_45_0_g2 = texCoord159;
				float2 appendResult4_g2 = (float2(1.0 , sqrt( 3.0 )));
				float2 HexAR21_g2 = appendResult4_g2;
				float2 h7_g2 = ( 0.5 * appendResult4_g2 );
				float2 A15_g2 = ( ( temp_output_45_0_g2 % HexAR21_g2 ) - h7_g2 );
				float ALength36_g2 = length( A15_g2 );
				float2 B16_g2 = ( ( ( temp_output_45_0_g2 - h7_g2 ) % HexAR21_g2 ) - h7_g2 );
				float BLength35_g2 = length( B16_g2 );
				float2 ifLocalVar19_g2 = 0;
				if( ALength36_g2 > BLength35_g2 )
				ifLocalVar19_g2 = B16_g2;
				else if( ALength36_g2 < BLength35_g2 )
				ifLocalVar19_g2 = A15_g2;
				float2 HexCoords260 = abs( ifLocalVar19_g2 );
				float2 break309 = HexCoords260;
				float4 lerpResult303 = lerp( color304 , color305 , saturate( ( break309.x + break309.y ) ));
				

				float4 color = saturate( ( tex2D( _MainTex, uv_MainTex ) + ( SinEdgeMask272 * lerpResult303 ) ) );
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18912
713;73;926;653;3160.527;451.8597;3.439708;True;False
Node;AmplifyShaderEditor.RangedFloatNode;146;-2512,64;Inherit;False;Constant;_5;.5;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;131;-2512,-128;Float;True;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;154;-2545,336;Inherit;False;Constant;_HexTiles;Hex Tiles;0;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;159;-2384,320;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.5,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;147;-2320,64;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;136;-2272,-96;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-2560,-272;Inherit;False;Constant;_Sinspeed;Sin speed;0;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;133;-2144,-96;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-2144,16;Inherit;False;Constant;_edgemaskPower;edge mask Power;0;0;Create;True;0;0;0;False;0;False;5;2.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;158;-2141.871,320;Inherit;False;Hexagon Tilemap;-1;;2;54bea1efc4d1c554c800cc886c500b2c;0;1;45;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;209;-2368,-272;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;140;-1936,-96;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-1920,16;Inherit;False;Constant;_edgemaskMultiply;edge mask Multiply;1;0;Create;True;0;0;0;False;0;False;7.29;0.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;172;-1886,320;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-2224,-192;Inherit;False;Constant;_Magicnumber;Magic number;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;208;-2176,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-1696,-96;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;260;-1723.768,312.7204;Inherit;False;HexCoords;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;210;-2032,-272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;302;-1488,-96;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-2032,-192;Inherit;False;Constant;_Sindivide;Sin divide;0;0;Create;True;0;0;0;False;0;False;3.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;306;-1152,1328;Inherit;False;260;HexCoords;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;309;-928,1312;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleDivideOpNode;212;-1872,-272;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;241;-1328,-112;Inherit;False;EdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;-1072,-272;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;308;-800,1312;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;272;-864,-272;Inherit;False;SinEdgeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;310;-672,1312;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;304;-928,960;Inherit;False;Constant;_HexcolorInside;Hex color Inside;0;0;Create;True;0;0;0;False;0;False;0,0.9582813,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;305;-926,1137;Inherit;False;Constant;_HexcolorEdge;Hex color Edge;0;0;Create;True;0;0;0;False;0;False;0.07069919,0,0.3679245,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;125;-48,688;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;296;-432,1024;Inherit;False;272;SinEdgeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;303;-448,1120;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;-192,1024;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;126;112,688;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;311;684.6157,759.9658;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;294;880,768;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1024,768;Float;False;True;-1;2;ASEMaterialInspector;0;2;Final/pp/cracked;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;159;0;154;0
WireConnection;147;0;146;0
WireConnection;147;1;146;0
WireConnection;136;0;131;1
WireConnection;136;1;131;2
WireConnection;133;0;136;0
WireConnection;133;1;147;0
WireConnection;158;45;159;0
WireConnection;209;0;215;0
WireConnection;140;0;133;0
WireConnection;140;1;142;0
WireConnection;172;0;158;0
WireConnection;208;0;209;0
WireConnection;139;0;140;0
WireConnection;139;1;141;0
WireConnection;260;0;172;0
WireConnection;210;0;208;0
WireConnection;210;1;211;0
WireConnection;302;0;139;0
WireConnection;309;0;306;0
WireConnection;212;0;210;0
WireConnection;212;1;213;0
WireConnection;241;0;302;0
WireConnection;271;0;212;0
WireConnection;271;1;241;0
WireConnection;308;0;309;0
WireConnection;308;1;309;1
WireConnection;272;0;271;0
WireConnection;310;0;308;0
WireConnection;303;0;304;0
WireConnection;303;1;305;0
WireConnection;303;2;310;0
WireConnection;284;0;296;0
WireConnection;284;1;303;0
WireConnection;126;0;125;0
WireConnection;311;0;126;0
WireConnection;311;1;284;0
WireConnection;294;0;311;0
WireConnection;0;0;294;0
ASEEND*/
//CHKSM=CF2F577B68B81CDEB7E840EC08CB91790EC7D45D