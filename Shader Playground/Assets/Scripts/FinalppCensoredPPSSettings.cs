// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( FinalppCensoredPPSRenderer ), PostProcessEvent.AfterStack, "FinalppCensored", true )]
public sealed class FinalppCensoredPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "render T" )]
	public TextureParameter _renderT = new TextureParameter {  };
}

public sealed class FinalppCensoredPPSRenderer : PostProcessEffectRenderer<FinalppCensoredPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "Final/pp/Censored" ) );
		if(settings._renderT.value != null) sheet.properties.SetTexture( "_renderT", settings._renderT );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
