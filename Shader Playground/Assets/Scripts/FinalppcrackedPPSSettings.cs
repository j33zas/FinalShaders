// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( FinalppcrackedPPSRenderer ), PostProcessEvent.AfterStack, "Finalppcracked", true )]
public sealed class FinalppcrackedPPSSettings : PostProcessEffectSettings
{
}

public sealed class FinalppcrackedPPSRenderer : PostProcessEffectRenderer<FinalppcrackedPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "Final/pp/cracked" ) );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
