// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Final/BurnAway"
{
	Properties
	{
		_FireSpeed("Fire Speed", Float) = 0.6
		_distortspeed("distort speed", Float) = 0.6
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Texture0("Texture 0", 2D) = "bump" {}
		_Texture1("Texture 1", 2D) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_Value("Value", Range( 0 , 1)) = 0
		_Normal("Normal", 2D) = "bump" {}
		_firespread("fire spread", Range( 0 , 1)) = 0
		_BurnEdge("Burn Edge", Range( 1 , 2)) = 0
		_DistortIntensity("Distort Intensity", Range( 0 , 0.1)) = 0
		_WhiteEdge("White Edge", Range( 1 , 1.1)) = 0
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _Texture1;
		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;
		uniform float _Value;
		uniform float _FireSpeed;
		uniform float _distortspeed;
		uniform float _DistortIntensity;
		uniform float _firespread;
		uniform float _BurnEdge;
		uniform float _WhiteEdge;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 Normal33 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			o.Normal = Normal33;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo32 = tex2D( _Albedo, uv_Albedo );
			o.Albedo = Albedo32.rgb;
			float4 color17 = IsGammaSpace() ? float4(1,0.9004603,0,0) : float4(1,0.7883235,0,0);
			float4 color16 = IsGammaSpace() ? float4(1,0.3431787,0,0) : float4(1,0.09646757,0,0);
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float mulTime13 = _Time.y * _FireSpeed;
			float2 panner11 = ( mulTime13 * float2( 0,1 ) + float2( 0,0 ));
			float2 uv_TexCoord15 = i.uv_texcoord + panner11;
			float4 AnimatedBurnMask93 = tex2D( _Texture1, ( ( (UnpackNormal( tex2D( _Texture0, uv_Texture0 ) )).xy * _Value ) + uv_TexCoord15 ) );
			float4 lerpResult18 = lerp( color17 , color16 , AnimatedBurnMask93);
			float4 temp_cast_1 = (1.79).xxxx;
			float mulTime78 = _Time.y * _distortspeed;
			float2 panner76 = ( mulTime78 * float2( 0,-1 ) + i.uv_texcoord);
			float BurnMask94 = tex2D( _Texture1, ( ( (UnpackNormal( tex2D( _Texture0, panner76 ) )).xy * _DistortIntensity ) + i.uv_texcoord ) ).r;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_65_0 = ( _firespread * ( ( 1.0 - ase_vertex3Pos.y ) + 2.0 ) );
			float temp_output_19_0 = step( BurnMask94 , temp_output_65_0 );
			float temp_output_62_0 = ( temp_output_19_0 - step( BurnMask94 , ( temp_output_65_0 / _BurnEdge ) ) );
			o.Emission = saturate( ( ( ( 0.97 * pow( lerpResult18 , temp_cast_1 ) ) * temp_output_62_0 ) + ( temp_output_62_0 - step( BurnMask94 , ( temp_output_65_0 / _WhiteEdge ) ) ) ) ).rgb;
			o.Alpha = 1;
			clip( temp_output_19_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16900
552;73;1140;506;1583.594;124.4643;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;100;-4443.285,-638.5417;Float;False;2005.061;516.5417;Comment;13;79;75;78;3;76;74;82;81;4;83;85;84;58;Fire Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;99;-3869.708,-16.34919;Float;False;1459.001;430;Comment;10;12;5;13;10;11;8;15;9;14;6;Fire edge;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-4393.285,-439.7598;Float;False;Property;_distortspeed;distort speed;1;0;Create;True;0;0;False;0;0.6;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;75;-4281.285,-567.7598;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-3819.708,289.6506;Float;False;Property;_FireSpeed;Fire Speed;0;0;Create;True;0;0;False;0;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-4096,-352;Float;True;Property;_Texture0;Texture 0;3;0;Create;True;0;0;False;0;None;b7bdc256e6a14f547b461dcd88dfbc31;True;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleTimeNode;78;-4217.286,-439.7598;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;13;-3643.708,289.6506;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;76;-4009.289,-567.7598;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-3819.708,33.65079;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-3534.708,129.6508;Float;False;Property;_Value;Value;6;0;Create;True;0;0;False;0;0;0.7590793;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;-3801.38,-588.5417;Float;True;Property;_TextureSample3;Texture Sample 3;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;11;-3467.708,257.6508;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;8;-3531.708,33.65079;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-3259.708,257.6508;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-3243.708,33.65079;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;81;-3513.288,-583.7598;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-3609.288,-391.7598;Float;False;Property;_DistortIntensity;Distort Intensity;10;0;Create;True;0;0;False;0;0;0.01;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-3289.288,-567.7598;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-2928,80;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-3062.669,-354.3464;Float;True;Property;_Texture1;Texture 1;4;0;Create;True;0;0;False;0;None;e9c51e3be909c8a43ae584dbb6db900d;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-3305.288,-423.7598;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;66;-1167,96;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;101;-959.5938,159.5357;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-2736,48;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-3069.326,-582.2576;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-768,128;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-912,0;Float;False;Property;_firespread;fire spread;8;0;Create;True;0;0;False;0;0;0.275;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;58;-2759.224,-472.9843;Float;True;Property;_TextureSample2;Texture Sample 2;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-2400,48;Float;False;AnimatedBurnMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-608,0;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-2432,-464;Float;False;BurnMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-640,144;Float;False;Property;_BurnEdge;Burn Edge;9;0;Create;True;0;0;False;0;0;1.1;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-671.4727,-580.6786;Float;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;1,0.3431787,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;98;-707.224,-406.0335;Float;False;93;AnimatedBurnMask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;17;-669.1902,-747.3033;Float;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;False;0;1,0.9004603,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;95;-624,-240;Float;False;94;BurnMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-321.1112,-91.39561;Float;False;94;BurnMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-354.1699,-509.9131;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-282.7242,-600.5776;Float;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;False;0;1.79;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;61;-320,0;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-601,240;Float;False;Property;_WhiteEdge;White Edge;11;0;Create;True;0;0;False;0;0;1.05;1;1.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;19;-416,-240;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-317.5658,147.926;Float;False;94;BurnMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-71.78974,-607.2984;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;0.97;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;26;-132.3254,-522.7365;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;59;-128,-81.59999;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;91;-288,224;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;24.76393,-528.3679;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;88;-128,208;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;-16,-208;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-2263.504,-1341.626;Float;True;Property;_Albedo;Albedo;5;0;Create;True;0;0;False;0;None;567de8287bc00f14789774284b5afd66;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-2262.711,-1144.341;Float;True;Property;_Normal;Normal;7;0;Create;True;0;0;False;0;None;9c2fcff9d02b12f4584a50c70e54895b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;192,-528;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;89;144,16;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;385.3923,-528;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1913.343,-1144.116;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1913.673,-1327.893;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;39;674.4636,-512.7692;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;648.8032,-711.904;Float;False;32;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;651.8173,-600.0383;Float;False;33;Normal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;896,-592;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Final/BurnAway;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;1;32;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;78;0;79;0
WireConnection;13;0;12;0
WireConnection;76;0;75;0
WireConnection;76;1;78;0
WireConnection;5;0;3;0
WireConnection;74;0;3;0
WireConnection;74;1;76;0
WireConnection;11;1;13;0
WireConnection;8;0;5;0
WireConnection;15;1;11;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;81;0;74;0
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;14;0;9;0
WireConnection;14;1;15;0
WireConnection;101;0;66;2
WireConnection;6;0;4;0
WireConnection;6;1;14;0
WireConnection;84;0;83;0
WireConnection;84;1;85;0
WireConnection;67;0;101;0
WireConnection;58;0;4;0
WireConnection;58;1;84;0
WireConnection;93;0;6;0
WireConnection;65;0;20;0
WireConnection;65;1;67;0
WireConnection;94;0;58;1
WireConnection;18;0;17;0
WireConnection;18;1;16;0
WireConnection;18;2;98;0
WireConnection;61;0;65;0
WireConnection;61;1;60;0
WireConnection;19;0;95;0
WireConnection;19;1;65;0
WireConnection;26;0;18;0
WireConnection;26;1;28;0
WireConnection;59;0;97;0
WireConnection;59;1;61;0
WireConnection;91;0;65;0
WireConnection;91;1;87;0
WireConnection;27;0;29;0
WireConnection;27;1;26;0
WireConnection;88;0;96;0
WireConnection;88;1;91;0
WireConnection;62;0;19;0
WireConnection;62;1;59;0
WireConnection;63;0;27;0
WireConnection;63;1;62;0
WireConnection;89;0;62;0
WireConnection;89;1;88;0
WireConnection;92;0;63;0
WireConnection;92;1;89;0
WireConnection;33;0;35;0
WireConnection;32;0;34;0
WireConnection;39;0;92;0
WireConnection;0;0;36;0
WireConnection;0;1;37;0
WireConnection;0;2;39;0
WireConnection;0;10;19;0
ASEEND*/
//CHKSM=1D2B72FBD4A4C8188F202844963DACFDDEFEC267