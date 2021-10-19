// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "River"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 7
		_FlowSpeed("Flow Speed", Float) = 0
		_flowmap("flowmap", 2D) = "white" {}
		_Colorheight("Color height", Float) = 0
		_TileNoise_UI_detail_level_3("TileNoise_UI_detail_level_3", 2D) = "white" {}
		_Intensity("Intensity", Range( 0 , 1)) = 1
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
		uniform float _FlowSpeed;
		uniform sampler2D _flowmap;
		uniform float _Intensity;
		uniform float _Colorheight;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float mulTime9 = _Time.y * _FlowSpeed;
			float mulTime26 = _Time.y * 0.0;
			float2 panner23 = ( mulTime26 * float2( 1,0 ) + v.texcoord.xy);
			float4 tex2DNode22 = tex2Dlod( _flowmap, float4( panner23, 0, 0.0) );
			float2 appendResult28 = (float2(tex2DNode22.r , tex2DNode22.g));
			float2 Flowmap29 = appendResult28;
			float2 uv_TexCoord7 = v.texcoord.xy + Flowmap29;
			float2 panner8 = ( mulTime9 * float2( 1,0.1 ) + uv_TexCoord7);
			float BnWmask31 = tex2Dlod( _TileNoise_UI_detail_level_3, float4( panner8, 0, 0.0) ).r;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 Vertexoffset33 = ( BnWmask31 * _Intensity * ( ase_worldNormal * float3(0,1,0) ) );
			v.vertex.xyz += Vertexoffset33;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color18 = IsGammaSpace() ? float4(0.1929067,0.8018868,0.6944197,0) : float4(0.03093756,0.6070304,0.4400829,0);
			float4 color19 = IsGammaSpace() ? float4(0.2861598,0.1863208,0.5,1) : float4(0.06657221,0.02900157,0.2140411,1);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult17 = lerp( color18 , color19 , ( ase_vertex3Pos.y * _Colorheight ));
			float4 Albedo36 = lerpResult17;
			o.Albedo = Albedo36.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
366;73;1156;518;2659.037;799.8367;1.927708;True;False
Node;AmplifyShaderEditor.RangedFloatNode;25;-3408,-1776;Inherit;False;Constant;_FlowmapSpeed;Flowmap Speed;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;27;-3200,-1904;Inherit;False;Constant;_FlowmapDir;Flowmap Dir;5;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-3264,-2032;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;26;-3216,-1776;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;23;-2960,-1920;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;22;-2768,-1936;Inherit;True;Property;_flowmap;flowmap;6;0;Create;True;0;0;0;False;0;False;-1;f2880439ff39ad94aac6aa10121c997a;f2880439ff39ad94aac6aa10121c997a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;28;-2464,-1888;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-2304,-1888;Inherit;False;Flowmap;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-2096,-288;Inherit;False;29;Flowmap;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2032,-48;Inherit;False;Property;_FlowSpeed;Flow Speed;5;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1856,-288;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;9;-1856,-48;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;11;-1856,-176;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;8;-1536,-208;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-1360,-208;Inherit;True;Property;_TileNoise_UI_detail_level_3;TileNoise_UI_detail_level_3;8;0;Create;True;0;0;0;False;0;False;-1;f5c0b8bf42c4f1b4f8b25386e0c7ccd5;e9c51e3be909c8a43ae584dbb6db900d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-831.2612,-193.7678;Inherit;False;BnWmask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;4;-1438.381,528;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;20;-3392,-1296;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-3376,-1136;Inherit;False;Property;_Colorheight;Color height;7;0;Create;True;0;0;0;False;0;False;0;3.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;5;-1438.381,672;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1214.381,528;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;18;-3136,-1456;Inherit;False;Constant;_Waves1;Waves 1;4;0;Create;True;0;0;0;False;0;False;0.1929067,0.8018868,0.6944197,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;32;-1438.381,368;Inherit;False;31;BnWmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1438.381,448;Inherit;False;Property;_Intensity;Intensity;9;0;Create;True;0;0;0;False;0;False;1;0.3896549;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-3136,-1296;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-3136,-1088;Inherit;False;Constant;_Waves2;Waves 2;4;0;Create;True;0;0;0;False;0;False;0.2861598,0.1863208,0.5,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1054.381,368;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;17;-2544,-1344;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-2384,-1344;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-912,368;Inherit;False;Vertexoffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;16,256;Inherit;False;33;Vertexoffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-3376,-1040;Inherit;False;31;BnWmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-11,-16;Inherit;False;36;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;240,-16;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;River;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;7;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;25;0
WireConnection;23;0;24;0
WireConnection;23;2;27;0
WireConnection;23;1;26;0
WireConnection;22;1;23;0
WireConnection;28;0;22;1
WireConnection;28;1;22;2
WireConnection;29;0;28;0
WireConnection;7;1;30;0
WireConnection;9;0;10;0
WireConnection;8;0;7;0
WireConnection;8;2;11;0
WireConnection;8;1;9;0
WireConnection;1;1;8;0
WireConnection;31;0;1;1
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;21;0;20;2
WireConnection;21;1;14;0
WireConnection;2;0;32;0
WireConnection;2;1;3;0
WireConnection;2;2;6;0
WireConnection;17;0;18;0
WireConnection;17;1;19;0
WireConnection;17;2;21;0
WireConnection;36;0;17;0
WireConnection;33;0;2;0
WireConnection;0;0;37;0
WireConnection;0;11;34;0
ASEEND*/
//CHKSM=A289308A9D1C1579D74D9E2B084D1EDABFF7B61E