Class {
	#name : #TargetTextureTile,
	#superclass : #StaticTextureTile,
	#category : #'SDLExperiments-Manager-Cairo'
}

{ #category : #'as yet unclassified' }
TargetTextureTile >> beTargetDuring: aBlock [
		
	SDL2
		ensureSuccessCode: (sdlRenderer setRenderTarget: sdlTexture)
		description: 'Set texture as target'.

	aBlock ensure: [ sdlRenderer noRenderTarget ]
]

{ #category : #'life cycle' }
TargetTextureTile >> createCairoObjects [

	cairoSurface := AeCairoImageSurface
		extent: pixelExtent
		format: AeCairoSurfaceFormat argb32.
	cairoSurface deviceScale: deviceScalePoint.

	cairoContext := cairoSurface newContext.

	cairoSurfaceStride := cairoSurface stride.
	cairoSurfacePixels := cairoSurface data

]

{ #category : #'life cycle' }
TargetTextureTile >> sdlTextureAccess [

	^ SDL_TEXTUREACCESS_TARGET
]
