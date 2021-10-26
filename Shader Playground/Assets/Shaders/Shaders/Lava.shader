// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lava"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 2
		[HDR]_LavaColor1("Lava Color 1", Color) = (0.754717,0.4531745,0,0)
		[HDR]_LavaColor2("Lava Color 2", Color) = (0.754717,0.4531745,0,0)
		_LavaFlowintensity("Lava Flow intensity", Float) = 0
		_LavaFlowPower("Lava Flow Power", Float) = 1
		_LavanoiseTexture("Lava noise Texture", 2D) = "white" {}
		[HDR]_GroundColor1("Ground Color 1", Color) = (0.2641509,0.1260773,0.01121395,0)
		[HDR]_GroundColor2("Ground Color 2", Color) = (1,0.8951166,0.7028302,0)
		_Cracksize("Crack size", Float) = 0.05
		_FlowSpeed("Flow Speed", Float) = 0
		_flowmap("flowmap", 2D) = "white" {}
		_Height("Height", Range( 0 , 1)) = 0
		_Voronoiangle("Voronoi angle", Float) = 0
		_voronoiScale("voronoi Scale", Float) = 0
		_AlbedoNoisescale("Albedo Noise scale", Float) = 1
		_AlbedonoisePower("Albedo noise Power", Float) = 1
		_AlbedoNoiseintensity("Albedo Noise intensity", Float) = 1.09
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _voronoiScale;
		uniform float _Voronoiangle;
		uniform float _Cracksize;
		uniform float _Height;
		uniform float4 _GroundColor1;
		uniform float4 _GroundColor2;
		uniform sampler2D _LavanoiseTexture;
		uniform float _AlbedoNoisescale;
		uniform float _AlbedoNoiseintensity;
		uniform float _AlbedonoisePower;
		uniform float4 _LavaColor1;
		uniform float4 _LavaColor2;
		uniform float _FlowSpeed;
		uniform sampler2D _flowmap;
		uniform float _LavaFlowintensity;
		uniform float _LavaFlowPower;
		uniform float _EdgeLength;


		float2 voronoihash1( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi1( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -3; j <= 3; j++ )
			{
				for ( int i = -3; i <= 3; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash1( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.707 * sqrt(dot( r, r ));
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F2 - F1;
		}


		//https://www.shadertoy.com/view/XdXGW8
		float2 GradientNoiseDir( float2 x )
		{
			const float2 k = float2( 0.3183099, 0.3678794 );
			x = x * k + k.yx;
			return -1.0 + 2.0 * frac( 16.0 * k * frac( x.x * x.y * ( x.x + x.y ) ) );
		}
		
		float GradientNoise( float2 UV, float Scale )
		{
			float2 p = UV * Scale;
			float2 i = floor( p );
			float2 f = frac( p );
			float2 u = f * f * ( 3.0 - 2.0 * f );
			return lerp( lerp( dot( GradientNoiseDir( i + float2( 0.0, 0.0 ) ), f - float2( 0.0, 0.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 0.0 ) ), f - float2( 1.0, 0.0 ) ), u.x ),
					lerp( dot( GradientNoiseDir( i + float2( 0.0, 1.0 ) ), f - float2( 0.0, 1.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 1.0 ) ), f - float2( 1.0, 1.0 ) ), u.x ), u.y );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float time1 = _Voronoiangle;
			float2 voronoiSmoothId0 = 0;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult88 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 coords1 = appendResult88 * _voronoiScale;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId0 );
			float Cracks17 = step( voroi1 , _Cracksize );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 VOffset56 = ( ( 1.0 - Cracks17 ) * ase_vertexNormal * float3(0,1,0) * _Height );
			v.vertex.xyz += VOffset56;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time1 = _Voronoiangle;
			float2 voronoiSmoothId0 = 0;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult88 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 coords1 = appendResult88 * _voronoiScale;
			float2 id1 = 0;
			float2 uv1 = 0;
			float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId0 );
			float Cracks17 = step( voroi1 , _Cracksize );
			float2 appendResult89 = (float2(ase_worldPos.x , ase_worldPos.z));
			float ColorMask97 = pow( ( tex2D( _LavanoiseTexture, ( appendResult89 * _AlbedoNoisescale ) ).r * _AlbedoNoiseintensity ) , _AlbedonoisePower );
			float4 lerpResult76 = lerp( _GroundColor1 , _GroundColor2 , saturate( ( ( 1.0 - Cracks17 ) * ColorMask97 ) ));
			float4 Albedo101 = ( lerpResult76 * ( 1.0 - Cracks17 ) );
			o.Albedo = Albedo101.rgb;
			float mulTime33 = _Time.y * _FlowSpeed;
			float mulTime26 = _Time.y * 0.3;
			float2 panner27 = ( mulTime26 * float2( 1,0 ) + i.uv_texcoord);
			float4 tex2DNode28 = tex2D( _flowmap, panner27 );
			float2 appendResult29 = (float2(tex2DNode28.r , tex2DNode28.g));
			float2 Flowmap30 = appendResult29;
			float2 uv_TexCoord59 = i.uv_texcoord + Flowmap30;
			float gradientNoise58 = GradientNoise(uv_TexCoord59,5.0);
			gradientNoise58 = gradientNoise58*0.5 + 0.5;
			float2 OffsetFlowmap106 = ( ( 1.0 - voroi1 ) * float2( 1,1 ) * gradientNoise58 );
			float2 uv_TexCoord32 = i.uv_texcoord + OffsetFlowmap106;
			float2 panner35 = ( mulTime33 * float2( 1,0.1 ) + uv_TexCoord32);
			float LavaFlowMask37 = tex2D( _LavanoiseTexture, panner35 ).r;
			float CracksShifted22 = step( voroi1 , ( _Cracksize * 0.8 ) );
			float4 lerpResult43 = lerp( _LavaColor1 , _LavaColor2 , ( pow( ( LavaFlowMask37 * _LavaFlowintensity ) , _LavaFlowPower ) * CracksShifted22 ));
			float4 LavaEmission72 = ( lerpResult43 * CracksShifted22 );
			o.Emission = LavaEmission72.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
310;73;772;341;4670.303;1081.653;3.007346;True;False
Node;AmplifyShaderEditor.CommentaryNode;39;-3808,-1008;Inherit;False;1397;421;Comment;8;23;24;25;26;27;28;29;30;Lava Flowmap;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-3760,-704;Inherit;False;Constant;_FlowmapSpeed;Flowmap Speed;3;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-3568,-704;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-3552,-944;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;24;-3552,-832;Inherit;False;Constant;_FlowmapDir;Flowmap Dir;5;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;27;-3312,-848;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;28;-3120,-864;Inherit;True;Property;_flowmap;flowmap;14;0;Create;True;0;0;0;False;0;False;-1;f2880439ff39ad94aac6aa10121c997a;f2880439ff39ad94aac6aa10121c997a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;41;-3808,-544;Inherit;False;1157;559;Comment;11;5;4;1;3;2;17;21;20;22;87;88;Cracks;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-2816,-816;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;87;-3792,-512;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;70;-3808,64;Inherit;False;1149.1;520.5;Comment;8;67;64;61;59;58;69;60;106;Offset flowmap;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-2656,-816;Inherit;False;Flowmap;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-3760,-368;Inherit;False;Property;_Voronoiangle;Voronoi angle;16;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-3760,320;Inherit;False;30;Flowmap;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3760,-288;Inherit;False;Property;_voronoiScale;voronoi Scale;17;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;-3616,-496;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-3568,448;Inherit;False;Constant;_bitch;??;10;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-3568,320;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;1;-3488,-496;Inherit;True;2;1;1;2;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.OneMinusNode;69;-3328,112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;67;-3328,192;Inherit;False;Constant;_Vector2;Vector 2;10;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;58;-3328,320;Inherit;False;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1.59;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-3082.799,115.9;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;104;-3792,-1840;Inherit;False;1369.37;337.7635;Comment;10;94;95;109;110;89;90;91;97;93;92;Noise Generator;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;90;-3744,-1776;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;40;-3808,-1472;Inherit;False;1398.582;409.1195;Comment;8;37;36;35;34;33;32;31;46;Lava Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-2864,112;Inherit;False;OffsetFlowmap;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-3744,-1632;Inherit;False;Property;_AlbedoNoisescale;Albedo Noise scale;18;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;89;-3568,-1776;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-3728,-1408;Inherit;True;106;OffsetFlowmap;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-3680,-1168;Inherit;False;Property;_FlowSpeed;Flow Speed;13;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-3504,-1168;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-3504,-1408;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;34;-3504,-1296;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-3424,-1776;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;35;-3184,-1328;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;109;-3296,-1776;Inherit;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;36;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;94;-3344,-1584;Inherit;False;Property;_AlbedoNoiseintensity;Albedo Noise intensity;20;0;Create;True;0;0;0;False;0;False;1.09;1.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-3488,-224;Inherit;False;Property;_Cracksize;Crack size;12;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-3088,-1584;Inherit;False;Property;_AlbedonoisePower;Albedo noise Power;19;0;Create;True;0;0;0;False;0;False;1;3.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-2944,-1792;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-3008,-1328;Inherit;True;Property;_LavanoiseTexture;Lava noise Texture;9;0;Create;True;0;0;0;False;0;False;-1;f5c0b8bf42c4f1b4f8b25386e0c7ccd5;e9c51e3be909c8a43ae584dbb6db900d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;2;-3104,-496;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;73;-4083.768,1168;Inherit;False;1400.919;621.561;Comment;13;53;55;72;45;43;19;8;42;54;83;84;85;86;Lava Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;93;-2816,-1792;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-2896,-496;Inherit;False;Cracks;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-2704,-1328;Inherit;False;LavaFlowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-3248,-208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;20;-3104,-240;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-2033,-656;Inherit;False;17;Cracks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-2672,-1776;Inherit;False;ColorMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-4048,1504;Inherit;False;37;LavaFlowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-4048,1584;Inherit;False;Property;_LavaFlowintensity;Lava Flow intensity;7;0;Create;True;0;0;0;False;0;False;0;1.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-3968,1664;Inherit;False;Property;_LavaFlowPower;Lava Flow Power;8;0;Create;True;0;0;0;False;0;False;1;1.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-3824,1552;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-2896,-240;Inherit;False;CracksShifted;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;78;-1856,-656;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-2048,-576;Inherit;False;97;ColorMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-3808,640;Inherit;False;928.4059;505.0277;Comment;7;56;11;15;16;18;9;14;Cracks vertex offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;85;-3696,1568;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-1552,-608;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-3760,1664;Inherit;False;22;CracksShifted;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;74;-1552,-768;Inherit;False;Property;_GroundColor2;Ground Color 2;11;1;[HDR];Create;True;0;0;0;False;0;False;1,0.8951166,0.7028302,0;0.1037736,0.07489321,0.07489321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;96;-1344,-608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-3568,1216;Inherit;False;Property;_LavaColor1;Lava Color 1;5;1;[HDR];Create;True;0;0;0;False;0;False;0.754717,0.4531745,0,0;0.64378,0.7529412,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;99;-1344,-528;Inherit;False;17;Cracks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-3504,1600;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-3776,704;Inherit;True;17;Cracks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;-3568,1392;Inherit;False;Property;_LavaColor2;Lava Color 2;6;1;[HDR];Create;True;0;0;0;False;0;False;0.754717,0.4531745,0,0;0.7529412,0.1701778,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;75;-1552,-944;Inherit;False;Property;_GroundColor1;Ground Color 1;10;1;[HDR];Create;True;0;0;0;False;0;False;0.2641509,0.1260773,0.01121395,0;0.09433961,0.02981487,0.02981487,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-3344,1632;Inherit;False;22;CracksShifted;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;9;-3568,704;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;15;-3568,768;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-3600,1056;Inherit;False;Property;_Height;Height;15;0;Create;True;0;0;0;False;0;False;0;0.106;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;76;-1184,-768;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;100;-1168,-528;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;14;-3568,912;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;43;-3264,1264;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-3072,1568;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-3296,704;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-874,-644;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-720,-624;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-3152,704;Inherit;False;VOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-2928,1568;Inherit;False;LavaEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-128,48;Inherit;False;72;LavaEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-128,272;Inherit;False;56;VOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-128,-32;Inherit;False;101;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;108;112,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Lava;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;2;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;23;0
WireConnection;27;0;25;0
WireConnection;27;2;24;0
WireConnection;27;1;26;0
WireConnection;28;1;27;0
WireConnection;29;0;28;1
WireConnection;29;1;28;2
WireConnection;30;0;29;0
WireConnection;88;0;87;1
WireConnection;88;1;87;3
WireConnection;59;1;61;0
WireConnection;1;0;88;0
WireConnection;1;1;5;0
WireConnection;1;2;4;0
WireConnection;69;0;1;0
WireConnection;58;0;59;0
WireConnection;58;1;60;0
WireConnection;64;0;69;0
WireConnection;64;1;67;0
WireConnection;64;2;58;0
WireConnection;106;0;64;0
WireConnection;89;0;90;1
WireConnection;89;1;90;3
WireConnection;33;0;31;0
WireConnection;32;1;46;0
WireConnection;110;0;89;0
WireConnection;110;1;91;0
WireConnection;35;0;32;0
WireConnection;35;2;34;0
WireConnection;35;1;33;0
WireConnection;109;1;110;0
WireConnection;92;0;109;1
WireConnection;92;1;94;0
WireConnection;36;1;35;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;93;0;92;0
WireConnection;93;1;95;0
WireConnection;17;0;2;0
WireConnection;37;0;36;1
WireConnection;21;0;3;0
WireConnection;20;0;1;0
WireConnection;20;1;21;0
WireConnection;97;0;93;0
WireConnection;83;0;53;0
WireConnection;83;1;84;0
WireConnection;22;0;20;0
WireConnection;78;0;77;0
WireConnection;85;0;83;0
WireConnection;85;1;86;0
WireConnection;81;0;78;0
WireConnection;81;1;98;0
WireConnection;96;0;81;0
WireConnection;55;0;85;0
WireConnection;55;1;54;0
WireConnection;9;0;18;0
WireConnection;76;0;75;0
WireConnection;76;1;74;0
WireConnection;76;2;96;0
WireConnection;100;0;99;0
WireConnection;43;0;8;0
WireConnection;43;1;42;0
WireConnection;43;2;55;0
WireConnection;45;0;43;0
WireConnection;45;1;19;0
WireConnection;11;0;9;0
WireConnection;11;1;15;0
WireConnection;11;2;14;0
WireConnection;11;3;16;0
WireConnection;82;0;76;0
WireConnection;82;1;100;0
WireConnection;101;0;82;0
WireConnection;56;0;11;0
WireConnection;72;0;45;0
WireConnection;108;0;102;0
WireConnection;108;2;71;0
WireConnection;108;11;57;0
ASEEND*/
//CHKSM=863869BDB9B4DACC9AF215649B80C26EC27A73C1