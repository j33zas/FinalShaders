// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Final/Laser"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 8
		_SegmentPow("Segment Pow", Float) = 1
		_edgeinfluence("edge influence", Range( 0 , 10)) = 0
		_SegmentMult("Segment Mult", Float) = 1
		_SegmentAmount("Segment Amount", Float) = 5
		_Segmentspeed("Segment speed", Float) = 0
		_Emmision("Emmision", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit alpha:fade keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			half filler;
		};

		uniform float _edgeinfluence;
		uniform float _SegmentAmount;
		uniform float _Segmentspeed;
		uniform float _SegmentMult;
		uniform float _SegmentPow;
		uniform float4 _Emmision;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_cast_0 = (_SegmentAmount).xx;
			float mulTime63 = _Time.y * _Segmentspeed;
			float2 uv_TexCoord55 = v.texcoord.xy * temp_cast_0 + ( mulTime63 * float2( 0,1 ) );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( saturate( ( 1.0 - abs( ( ( v.texcoord.xy.y - 0.5 ) * _edgeinfluence ) ) ) ) * pow( ( abs( sin( uv_TexCoord55.y ) ) * _SegmentMult ) , _SegmentPow ) * ase_vertexNormal ) / 500.0 );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = _Emmision.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
1038;119;947;530;1930.591;469.1663;1.428092;True;False
Node;AmplifyShaderEditor.RangedFloatNode;77;-1744,-96;Inherit;False;Property;_Segmentspeed;Segment speed;9;0;Create;True;0;0;0;False;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;75;-1536,-32;Inherit;False;Constant;_Direction;Direction;2;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;63;-1536,-96;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1376,-96;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;93;-1216,-400;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-1536,-176;Inherit;False;Property;_SegmentAmount;Segment Amount;8;0;Create;True;0;0;0;False;0;False;5;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-1216,-192;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;87;-960,-352;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1216,-272;Inherit;False;Property;_edgeinfluence;edge influence;6;0;Create;True;0;0;0;False;0;False;0;1.75;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-800,-240;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;81;-960,-144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-894,-48;Inherit;False;Property;_SegmentMult;Segment Mult;7;0;Create;True;0;0;0;False;0;False;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;86;-672,-240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;82;-816,-144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-624,-144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;91;-560,-240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-672,-48;Inherit;False;Property;_SegmentPow;Segment Pow;5;0;Create;True;0;0;0;False;0;False;1;3.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;70;-496,-48;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;92;-416,-240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;65;-496,-144;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-192,-32;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;500;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-192,-176;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;71;-496,96;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;1,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;79;64,-432;Inherit;False;Property;_Emmision;Emmision;10;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4716981,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;72;16,-176;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;78;304,-432;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;Final/Laser;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;8;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;0;77;0
WireConnection;74;0;63;0
WireConnection;74;1;75;0
WireConnection;55;0;60;0
WireConnection;55;1;74;0
WireConnection;87;0;93;2
WireConnection;89;0;87;0
WireConnection;89;1;90;0
WireConnection;81;0;55;2
WireConnection;86;0;89;0
WireConnection;82;0;81;0
WireConnection;64;0;82;0
WireConnection;64;1;66;0
WireConnection;91;0;86;0
WireConnection;92;0;91;0
WireConnection;65;0;64;0
WireConnection;65;1;67;0
WireConnection;69;0;92;0
WireConnection;69;1;65;0
WireConnection;69;2;70;0
WireConnection;72;0;69;0
WireConnection;72;1;73;0
WireConnection;78;2;79;0
WireConnection;78;11;72;0
ASEEND*/
//CHKSM=2C7FA1285A3A07E5F43ED8F117301E036D9CDD2E