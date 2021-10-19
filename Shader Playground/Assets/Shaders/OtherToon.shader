// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "OtherToon"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_FlowmapStrength("Flowmap Strength", Float) = 0
		_TileNoise_UI_detail_level_3("TileNoise_UI_detail_level_3", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample1;
		uniform sampler2D _TileNoise_UI_detail_level_3;
		uniform float4 _TileNoise_UI_detail_level_3_ST;
		uniform float _FlowmapStrength;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TileNoise_UI_detail_level_3 = i.uv_texcoord * _TileNoise_UI_detail_level_3_ST.xy + _TileNoise_UI_detail_level_3_ST.zw;
			float4 tex2DNode26 = tex2D( _TileNoise_UI_detail_level_3, uv_TileNoise_UI_detail_level_3 );
			float2 appendResult21 = (float2(tex2DNode26.r , tex2DNode26.r));
			float mulTime17 = _Time.y * 0.2;
			float2 appendResult24 = (float2(0.0 , mulTime17));
			float2 uv_TexCoord16 = i.uv_texcoord * ( appendResult21 * _FlowmapStrength ) + appendResult24;
			o.Albedo = tex2D( _TextureSample1, uv_TexCoord16 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
297;73;788;341;2070.333;265.2654;1.966749;True;False
Node;AmplifyShaderEditor.RangedFloatNode;19;-1200,272;Inherit;False;Constant;_Scrollspeed;Scroll speed;1;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1328,112;Inherit;False;Property;_FlowmapStrength;Flowmap Strength;1;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-1383.938,-107.9254;Inherit;True;Property;_TileNoise_UI_detail_level_3;TileNoise_UI_detail_level_3;2;0;Create;True;0;0;0;False;0;False;-1;f5c0b8bf42c4f1b4f8b25386e0c7ccd5;f5c0b8bf42c4f1b4f8b25386e0c7ccd5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;17;-1024,272;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;25;-912,48;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-1024,-48;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-864,272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-880,-48;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-716.8729,-62.50729;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-480,-80;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;9db487c79cba7d44b94127e4f5c2f4c7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;OtherToon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;19;0
WireConnection;25;0;23;0
WireConnection;21;0;26;1
WireConnection;21;1;26;1
WireConnection;24;1;17;0
WireConnection;22;0;21;0
WireConnection;22;1;25;0
WireConnection;16;0;22;0
WireConnection;16;1;24;0
WireConnection;18;1;16;0
WireConnection;0;0;18;0
ASEEND*/
//CHKSM=8E1367B23C77EB698730F714AFECFD120595601F