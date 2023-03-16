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
StaticTextureTile >> createCairoObjects [

	cairoSurface := AeCairoImageSurface
		extent: pixelExtent
		format: AeCairoSurfaceFormat argb32.
	cairoSurface deviceScale: deviceScalePoint.

	cairoContext := cairoSurface newContext.

	cairoSurfaceStride := cairoSurface stride.
	cairoSurfacePixels := cairoSurface data

]

{ #category : #'life cycle' }
StaticTextureTile >> sdlTextureAccess [

	^ SDL_TEXTUREACCESS_STATIC
]

{ #category : #'life cycle' }
StaticTextureTile >> sdlTextureBlendMode [

	^ SDL2 premultipliedAlphaBlendMode
]
