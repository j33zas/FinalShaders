// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Final/FireDissolve"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Normal("Normal", 2D) = "bump" {}
		_Burncolor1("Burn color 1", Color) = (0,0,0,0)
		_Burncolor2("Burn color 2", Color) = (0,0,0,0)
		_BurnEdge("Burn Edge", Range( 0.5 , 1)) = 0.5721019
		_Opacitythreshhold("Opacity threshhold", Range( 0 , 1)) = 0.3485823
		_Noisetiling("Noise tiling", Vector) = (0,0,0,0)
		_transition("transition", Range( -2 , 3)) = 0
		_Albedo("Albedo", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma exclude_renderers switch nomrt 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Burncolor2;
		uniform float4 _Burncolor1;
		uniform float _transition;
		uniform float2 _Noisetiling;
		uniform float _BurnEdge;
		uniform float _Opacitythreshhold;
		uniform float _Cutoff = 0.5;
		uniform float _TessValue;
		uniform float _TessPhongStrength;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( )
		{
			return _TessValue;
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 Normal169 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			o.Normal = Normal169;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo173 = tex2D( _Albedo, uv_Albedo );
			o.Albedo = Albedo173.rgb;
			float2 temp_cast_1 = (29.05).xx;
			float2 uv_TexCoord131 = i.uv_texcoord * temp_cast_1;
			float2 panner163 = ( _Time.y * float2( 0,2 ) + uv_TexCoord131);
			float simplePerlin2D121 = snoise( panner163 );
			float AnimatedNoise119 = simplePerlin2D121;
			float4 lerpResult113 = lerp( _Burncolor2 , _Burncolor1 , saturate( AnimatedNoise119 ));
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float2 uv_TexCoord12 = i.uv_texcoord * _Noisetiling;
			float simplePerlin2D19 = snoise( uv_TexCoord12 );
			half Noise70 = simplePerlin2D19;
			float temp_output_37_0 = ( ase_vertex3Pos.y + _transition + Noise70 );
			float4 temp_cast_2 = (2.0).xxxx;
			o.Emission = saturate( pow( ( lerpResult113 * step( ( 1.0 - temp_output_37_0 ) , _BurnEdge ) ) , temp_cast_2 ) ).rgb;
			o.Alpha = 1;
			clip( saturate( step( temp_output_37_0 , _Opacitythreshhold ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
651;73;842;653;1329.797;342.7565;1.581564;True;False
Node;AmplifyShaderEditor.RangedFloatNode;162;-3767.209,-622.7868;Float;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-3771.024,-739.2559;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;29.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;20;-3780.761,-883.6898;Float;False;Property;_Noisetiling;Noise tiling;11;0;Create;True;0;0;0;False;0;False;0,0;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;131;-3588.761,-755.6898;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;161;-3537.525,-619.0822;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-3588.761,-899.6898;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;163;-3342.819,-751.8493;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;19;-3199.742,-907.1917;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-2991.742,-907.1917;Half;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;121;-3147.3,-755.6898;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1184,304;Float;False;Property;_transition;transition;12;0;Create;True;0;0;0;False;0;False;0;-0.71;-2;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;29;-1119.316,164.2816;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-2955.3,-755.6898;Float;False;AnimatedNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1088,384;Inherit;False;70;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-896,288;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;-0.26;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-1186.901,-54.2691;Inherit;False;119;AnimatedNoise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;68;-608,64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;172;-963.5722,-49.78761;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-768,-64;Float;False;Property;_BurnEdge;Burn Edge;9;0;Create;True;0;0;0;False;0;False;0.5721019;0.558;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;111;-1172.73,-380.4218;Float;False;Property;_Burncolor2;Burn color 2;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6903414,0.990566,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;112;-1171.547,-216.6251;Float;False;Property;_Burncolor1;Burn color 1;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.764151,0.5580802,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;113;-794.6909,-301.4326;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;184;-416,-80;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-64,-256;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;183;0,-48;Float;False;Constant;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;55;-3830.637,-1499.423;Inherit;True;Property;_Albedo;Albedo;13;0;Create;True;0;0;0;False;0;False;-1;None;c21246c399c4fb246b5bf9ec58a46f7b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;110;-3820.175,-1278.235;Inherit;True;Property;_Normal;Normal;6;0;Create;True;0;0;0;False;0;False;-1;None;ab17411af7d6be94ab66f628272bb3e7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;195;-864,416;Float;False;Property;_Opacitythreshhold;Opacity threshhold;10;0;Create;True;0;0;0;False;0;False;0.3485823;0.8029411;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;169;-3450.821,-1273.081;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;182;176,-240;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;173;-3462.113,-1479.484;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;194;-592,288;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;196;-909.4977,136.2822;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;174;340.2353,-358.3445;Inherit;False;173;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;181;372.2353,-230.3445;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;38;-464,288;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;340.2353,-294.3445;Inherit;False;169;Normal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;551.7849,-328.3834;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Final/FireDissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;ForwardOnly;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;32;10;25;True;1;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;131;0;151;0
WireConnection;161;0;162;0
WireConnection;12;0;20;0
WireConnection;163;0;131;0
WireConnection;163;1;161;0
WireConnection;19;0;12;0
WireConnection;70;0;19;0
WireConnection;121;0;163;0
WireConnection;119;0;121;0
WireConnection;37;0;29;2
WireConnection;37;1;31;0
WireConnection;37;2;71;0
WireConnection;68;0;37;0
WireConnection;172;0;120;0
WireConnection;113;0;111;0
WireConnection;113;1;112;0
WireConnection;113;2;172;0
WireConnection;184;0;68;0
WireConnection;184;1;185;0
WireConnection;139;0;113;0
WireConnection;139;1;184;0
WireConnection;169;0;110;0
WireConnection;182;0;139;0
WireConnection;182;1;183;0
WireConnection;173;0;55;0
WireConnection;194;0;37;0
WireConnection;194;1;195;0
WireConnection;181;0;182;0
WireConnection;38;0;194;0
WireConnection;0;0;174;0
WireConnection;0;1;170;0
WireConnection;0;2;181;0
WireConnection;0;10;38;0
ASEEND*/
//CHKSM=C8A6BB90091523AE817691C39D4C20C573370F03