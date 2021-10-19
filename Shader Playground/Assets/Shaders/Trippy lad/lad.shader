// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "clase02/trippy lad"
{
	Properties
	{
		_freq("freq", Float) = 0
		_amp("amp", Float) = 0
		_time("time", Float) = 0
		_tint1("tint 1", Color) = (0,0,0,0)
		_powerfresnel("power fresnel", Float) = 0
		_scalefresnel("scale fresnel", Float) = 0
		_tint2("tint 2", Color) = (0,0,1,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _tint1;
		uniform float4 _tint2;
		uniform float _freq;
		uniform float _time;
		uniform float _amp;
		uniform float _scalefresnel;
		uniform float _powerfresnel;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 lerpResult39 = lerp( _tint1 , _tint2 , ( ( _SinTime.w + 1.0 ) / 2.0 ));
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float mulTime18 = _Time.y * _time;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV32 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode32 = ( 0.0 + _scalefresnel * pow( 1.0 - fresnelNdotV32, _powerfresnel ) );
			float temp_output_26_0 = saturate( ( saturate( ( ( sin( ( ( ase_vertex3Pos.y * _freq ) + mulTime18 ) ) * _amp ) + 0.0 ) ) + fresnelNode32 ) );
			o.Emission = ( lerpResult39 * temp_output_26_0 ).rgb;
			o.Alpha = temp_output_26_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16900
389;73;1529;521;2733.589;409.9139;1.703908;True;False
Node;AmplifyShaderEditor.RangedFloatNode;15;-1905.08,78.78629;Float;False;Property;_freq;freq;0;0;Create;True;0;0;False;0;0;70;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;37;-1948.762,-125.4157;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-1895.439,161.6877;Float;False;Property;_time;time;2;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;18;-1696.171,167.1223;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1629.969,-52.47604;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1491.467,54.80704;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;11;-1346.049,56.16503;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1357.956,143.292;Float;False;Property;_amp;amp;1;0;Create;True;0;0;False;0;0;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1176.252,48.90362;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1310.552,224.3692;Float;False;Constant;_opacity;opacity;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;40;-1011.718,-194.0869;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1259.835,457.6517;Float;False;Property;_powerfresnel;power fresnel;4;0;Create;True;0;0;False;0;0;13.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-991.051,120.3389;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1258.086,378.974;Float;False;Property;_scalefresnel;scale fresnel;5;0;Create;True;0;0;False;0;0;-736.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-845.7599,-127.1704;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;32;-994.5731,319.3705;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;-841.976,148.7887;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-847.3639,-551.7056;Float;False;Property;_tint1;tint 1;3;0;Create;True;0;0;False;0;0,0,0,0;1,0.5850748,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-658.0204,202.694;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-849.231,-348.9037;Float;False;Property;_tint2;tint 2;6;0;Create;True;0;0;False;0;0,0,1,0;0,0.9233861,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;42;-700.6893,-134.0785;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;26;-339.0395,177.6995;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;39;-534.8062,-360.9198;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-28.35771,75.21184;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;43;-1885.95,-120.4053;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;184.6791,-35.97645;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;clase02/trippy lad;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;20;0
WireConnection;14;0;37;2
WireConnection;14;1;15;0
WireConnection;19;0;14;0
WireConnection;19;1;18;0
WireConnection;11;0;19;0
WireConnection;17;0;11;0
WireConnection;17;1;16;0
WireConnection;36;0;17;0
WireConnection;36;1;25;0
WireConnection;41;0;40;4
WireConnection;32;2;34;0
WireConnection;32;3;33;0
WireConnection;22;0;36;0
WireConnection;24;0;22;0
WireConnection;24;1;32;0
WireConnection;42;0;41;0
WireConnection;26;0;24;0
WireConnection;39;0;21;0
WireConnection;39;1;38;0
WireConnection;39;2;42;0
WireConnection;23;0;39;0
WireConnection;23;1;26;0
WireConnection;0;2;23;0
WireConnection;0;9;26;0
ASEEND*/
//CHKSM=6CCA2CF383573208DCE627D62D7A4A9152D945CE