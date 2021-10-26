// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hexagon"
{
	Properties
	{
		_HexSize("Hex Size", Range( 0 , 0.5)) = 0.324073
		[IntRange]_Hextiling("Hex tiling", Range( 1 , 10)) = 1
		_EdgeSize("Edge Size", Range( 0 , 0.3)) = 0.04310423
		_Insidesize("Inside size", Range( 0 , 1)) = 0.5294117
		_Xoffset("X offset", Range( 0 , 1)) = 0
		_Yoffset("Y offset", Range( 0 , 1)) = 0
		_OffsetSpeed("Offset Speed", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Hextiling;
		uniform float _Xoffset;
		uniform float _Yoffset;
		uniform float _OffsetSpeed;
		uniform float _EdgeSize;
		uniform float _HexSize;
		uniform float _Insidesize;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color410 = IsGammaSpace() ? float4(0.4,1.47451,1.466667,0) : float4(0.1328683,2.349768,2.322359,0);
			float2 appendResult95_g2 = (float2(1.0 , sqrt( 3.0 )));
			float2 normalizeResult96_g2 = normalize( appendResult95_g2 );
			float2 HexAspectRatio97_g2 = normalizeResult96_g2;
			float2 temp_cast_0 = (_Hextiling).xx;
			float2 appendResult405 = (float2(_Xoffset , _Yoffset));
			float2 uv_TexCoord1 = i.uv_texcoord * temp_cast_0 + ( _Time.y * appendResult405 * _OffsetSpeed );
			float2 temp_output_74_0_g2 = ( 1.0 - uv_TexCoord1 );
			float2 temp_cast_1 = (0.5).xx;
			float2 GridA87_g2 = abs( sin( ( frac( ( temp_output_74_0_g2 + 0.5 ) ) - temp_cast_1 ) ) );
			float dotResult22_g2 = dot( HexAspectRatio97_g2 , GridA87_g2 );
			float EdgeSize99_g2 = _EdgeSize;
			float dotResult26_g2 = dot( ( HexAspectRatio97_g2 * float2( -1,1 ) ) , GridA87_g2 );
			float HexSize63_g2 = _HexSize;
			float InsideSize65_g2 = _Insidesize;
			float temp_output_49_0_g2 = ( HexSize63_g2 * InsideSize65_g2 );
			float dotResult44_g2 = dot( GridA87_g2 , HexAspectRatio97_g2 );
			float temp_output_50_0_g2 = max( dotResult44_g2 , GridA87_g2.x );
			float2 temp_cast_2 = (0.5).xx;
			float2 GridB88_g2 = abs( sin( ( frac( temp_output_74_0_g2 ) - temp_cast_2 ) ) );
			float dotResult41_g2 = dot( GridB88_g2 , HexAspectRatio97_g2 );
			float temp_output_51_0_g2 = max( dotResult41_g2 , GridB88_g2.x );
			float dotResult21_g2 = dot( HexAspectRatio97_g2 , GridB88_g2 );
			float dotResult23_g2 = dot( ( HexAspectRatio97_g2 * float2( -1,1 ) ) , GridB88_g2 );
			o.Emission = ( color410 * saturate( ( ( ( 1.0 - ( step( abs( dotResult22_g2 ) , EdgeSize99_g2 ) + step( abs( dotResult26_g2 ) , EdgeSize99_g2 ) + step( abs( GridA87_g2.x ) , EdgeSize99_g2 ) ) ) * step( temp_output_49_0_g2 , temp_output_50_0_g2 ) * step( temp_output_50_0_g2 , HexSize63_g2 ) ) + ( step( temp_output_49_0_g2 , temp_output_51_0_g2 ) * step( temp_output_51_0_g2 , HexSize63_g2 ) * ( 1.0 - ( step( abs( GridB88_g2.x ) , EdgeSize99_g2 ) + step( abs( dotResult21_g2 ) , EdgeSize99_g2 ) + step( abs( dotResult23_g2 ) , EdgeSize99_g2 ) ) ) ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
429;73;1094;927;941.6091;778.7972;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;404;-1664,-304;Inherit;False;Property;_Yoffset;Y offset;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;403;-1664,-384;Inherit;False;Property;_Xoffset;X offset;4;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;402;-1360,-432;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;405;-1328,-352;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;408;-1376,-224;Inherit;False;Property;_OffsetSpeed;Offset Speed;6;0;Create;True;0;0;0;False;0;False;0.1;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;406;-1168,-384;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1456,-512;Inherit;False;Property;_Hextiling;Hex tiling;1;1;[IntRange];Create;True;0;0;0;False;0;False;1;4;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-960,-528;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,32;False;1;FLOAT2;0.5,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-736,-464;Inherit;False;Property;_HexSize;Hex Size;0;0;Create;True;0;0;0;False;0;False;0.324073;0.303;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-736,-384;Inherit;False;Property;_Insidesize;Inside size;3;0;Create;True;0;0;0;False;0;False;0.5294117;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-736,-304;Inherit;False;Property;_EdgeSize;Edge Size;2;0;Create;True;0;0;0;False;0;False;0.04310423;0.032;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;410;-384,-752;Inherit;False;Constant;_Emmisioncolor;Emmision color;7;1;[HDR];Create;True;0;0;0;False;0;False;0.4,1.47451,1.466667,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;430;-400,-528;Inherit;True;HexagonGenerator;-1;;2;83d43f843483102449ef3b8e2d0f29c5;0;4;106;FLOAT2;0,0;False;100;FLOAT;0.3;False;102;FLOAT;0.8;False;104;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;425;-64,-560;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;320,-624;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Hexagon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;405;0;403;0
WireConnection;405;1;404;0
WireConnection;406;0;402;0
WireConnection;406;1;405;0
WireConnection;406;2;408;0
WireConnection;1;0;96;0
WireConnection;1;1;406;0
WireConnection;430;106;1;0
WireConnection;430;100;14;0
WireConnection;430;102;150;0
WireConnection;430;104;180;0
WireConnection;425;0;410;0
WireConnection;425;1;430;0
WireConnection;0;2;425;0
ASEEND*/
//CHKSM=856E9C2535B538B022E0041F0911FF69808B027E