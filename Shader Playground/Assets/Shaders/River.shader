// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "River"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 7
		_flowmap("flowmap", 2D) = "white" {}
		_Colorheight("Color height", Float) = 0
		_TileNoise_UI_detail_level_3("TileNoise_UI_detail_level_3", 2D) = "white" {}
		_Intensity("Intensity", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
		};

		uniform sampler2D _TileNoise_UI_detail_level_3;
		uniform sampler2D _flowmap;
		uniform float4 _flowmap_ST;
		uniform float _Intensity;
		uniform float _Colorheight;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime9 = _Time.y * 0.62;
			float2 uv_flowmap = v.texcoord * _flowmap_ST.xy + _flowmap_ST.zw;
			float2 uv_TexCoord7 = v.texcoord.xy + tex2Dlod( _flowmap, float4( uv_flowmap, 0, 0.0) ).rg;
			float2 panner8 = ( mulTime9 * float2( 1,0 ) + uv_TexCoord7);
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += ( tex2Dlod( _TileNoise_UI_detail_level_3, float4( panner8, 0, 0.0) ) * _Intensity * float4( ( ase_worldNormal * float3(0,1,0) ) , 0.0 ) ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color18 = IsGammaSpace() ? float4(0,1,0.8245816,0) : float4(0,1,0.6463339,0);
			float4 color19 = IsGammaSpace() ? float4(0.2861598,0.1863208,0.5,0.6784314) : float4(0.06657223,0.02900156,0.2140411,0.6784314);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult17 = lerp( color18 , color19 , ( ase_vertex3Pos.y * _Colorheight ));
			o.Albedo = lerpResult17.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
250;73;832;341;982.7172;-914.2603;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;10;-1360,512;Inherit;False;Constant;_FlowSpeed;Flow Speed;3;0;Create;True;0;0;0;False;0;False;0.62;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-1793.493,230.5949;Inherit;True;Property;_flowmap;flowmap;5;0;Create;True;0;0;0;False;0;False;-1;f2880439ff39ad94aac6aa10121c997a;f2880439ff39ad94aac6aa10121c997a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1264,272;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;11;-1186.947,400.8471;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;9;-1200,512;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;8;-947.1189,379.8893;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;5;-672,768;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;20;-560,928;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-544,1088;Inherit;False;Property;_Colorheight;Color height;6;0;Create;True;0;0;0;False;0;False;0;3.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;4;-672,624;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;-704,352;Inherit;True;Property;_TileNoise_UI_detail_level_3;TileNoise_UI_detail_level_3;7;0;Create;True;0;0;0;False;0;False;-1;f5c0b8bf42c4f1b4f8b25386e0c7ccd5;f5c0b8bf42c4f1b4f8b25386e0c7ccd5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;-256,496;Inherit;False;Constant;_Waves1;Waves 1;4;0;Create;True;0;0;0;False;0;False;0,1,0.8245816,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-288,928;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-256,656;Inherit;False;Constant;_Waves2;Waves 2;4;0;Create;True;0;0;0;False;0;False;0.2861598,0.1863208,0.5,0.6784314;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-448,688;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-676.5951,554.1206;Inherit;False;Property;_Intensity;Intensity;8;0;Create;True;0;0;0;False;0;False;1;0.3896549;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-336,368;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;17;64,608;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;240,-16;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;River;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;7;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;1;22;0
WireConnection;9;0;10;0
WireConnection;8;0;7;0
WireConnection;8;2;11;0
WireConnection;8;1;9;0
WireConnection;1;1;8;0
WireConnection;21;0;20;2
WireConnection;21;1;14;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;2;2;6;0
WireConnection;17;0;18;0
WireConnection;17;1;19;0
WireConnection;17;2;21;0
WireConnection;0;0;17;0
WireConnection;0;11;2;0
ASEEND*/
//CHKSM=D7D4B40B5A1A17A47B45BFA1151C60B4B8C13904