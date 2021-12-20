// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LerpShader"
{
	Properties
	{
		_ShotsReceived("ShotsReceived", Float) = 0
		_Index("Index", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 positionsArray[3];
		uniform float _Index;
		uniform float _ShotsReceived;


		float DistanceCheck150( float3 WorldPos, float3 objectPosition, int index, int shotsReceived )
		{
			float closest=10000;
			float now=0;
			for(int i=index; i<index+shotsReceived;i++){
				now = distance(WorldPos,positionsArray[i]);
				if(now < closest){
				closest = now;
				}
			}
			return closest;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 WorldPos150 = ase_worldPos;
			float3 objectPosition150 = positionsArray[clamp(0,0,(3 - 1))].xyz;
			int index150 = (int)_Index;
			int shotsReceived150 = (int)_ShotsReceived;
			float localDistanceCheck150 = DistanceCheck150( WorldPos150 , objectPosition150 , index150 , shotsReceived150 );
			float3 temp_cast_3 = (localDistanceCheck150).xxx;
			o.Albedo = temp_cast_3;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
754;73;480;655;-586.2771;149.2561;1;False;False
Node;AmplifyShaderEditor.WorldPosInputsNode;21;357.4803,-118.8332;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;170;247.3889,413.5989;Inherit;False;Property;_ShotsReceived;ShotsReceived;0;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;285.2575,315.0458;Inherit;False;Property;_Index;Index;1;0;Create;True;0;0;0;False;0;False;0;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;40;256.8126,77.29783;Inherit;False;positionsArray;0;3;2;True;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;150;588.0064,-2.675183;Float;False;float closest=10000@$float now=0@$for(int i=index@ i<index+shotsReceived@i++){$	now = distance(WorldPos,positionsArray[i])@$	if(now < closest){$	closest = now@$	}$}$return closest@$$;1;False;4;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;objectPosition;FLOAT3;0,0,0;In;;Float;False;True;index;INT;0;In;;Float;False;True;shotsReceived;INT;0;In;;Float;False;DistanceCheck;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;INT;0;False;3;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;845.1921,7.126343;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LerpShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;150;0;21;0
WireConnection;150;1;40;0
WireConnection;150;2;171;0
WireConnection;150;3;170;0
WireConnection;0;0;150;0
ASEEND*/
//CHKSM=519111B87AE3226CD26CE843A24620D97D3FB46B