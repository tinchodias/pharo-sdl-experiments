Class {
	#name : #StaticTextureTile,
	#superclass : #TextureTile,
	#instVars : [
		'cairoSurface',
		'cairoContext',
		'cairoSurfacePixels',
		'cairoSurfaceStride'
	],
	#category : #'SDLExperiments-Manager-Texture'
}

{ #category : #accessing }
StaticTextureTile >> cairoContext [

	^ cairoContext
]

{ #category : #enumerating }
StaticTextureTile >> cairoContextToOverrideDo: aBlock [

	cairoContext
		clearTransparent;
		restoreStateAfter: [
			aBlock value: cairoContext ].
	cairoSurface flush.

	sdlTexture
		updateTextureRect: SDL_Rect null
			pixels: cairoSurfacePixels
			pitch:  cairoSurfaceStride

]

{ #category : #'life cycle' }
StaticTextureTile >> createTexture [

	sdlTexture := sdlRenderer
		createTextureFormat: SDL_PIXELFORMAT_ARGB8888
		access: SDL_TEXTUREACCESS_STATIC
		width: pixelExtent x
		height: pixelExtent y.
	sdlTexture blendMode: SDL2 premultipliedAlphaBlendMode.
	
	cairoSurface := AeCairoImageSurface
		extent: pixelExtent
		format: AeCairoSurfaceFormat argb32.
	cairoSurface deviceScale: deviceScalePoint.

	cairoContext := cairoSurface newContext.

	cairoSurfaceStride := cairoSurface stride.
	cairoSurfacePixels := cairoSurface data

]
