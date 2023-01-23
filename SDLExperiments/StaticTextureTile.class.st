Class {
	#name : #StaticTextureTile,
	#superclass : #TextureTile,
	#instVars : [
		'sdlSurface',
		'cairoSurface',
		'cairoContext'
	],
	#category : #'SDLExperiments-Texture'
}

{ #category : #enumerating }
StaticTextureTile >> cairoContextToOverrideDo: aBlock [

	aBlock value: cairoContext.

	cairoSurface flush.

	sdlTexture
		updateTextureRect: SDL_Rect null
			pixels: sdlSurface pixels
			pitch:  sdlSurface pitch.

]

{ #category : #'life cycle' }
StaticTextureTile >> createTexture [

	sdlSurface := SDL2
		createRGBSurfaceWithFormat: SDL_PIXELFORMAT_ARGB8888
		depth: 32
		width: pixelExtent x
		height: pixelExtent y.

	sdlTexture := sdlRenderer
		createTextureFormat: SDL_PIXELFORMAT_ARGB8888
		access: SDL_TEXTUREACCESS_STATIC
		width: pixelExtent x
		height: pixelExtent y.
	sdlTexture blendMode: SDL_BLENDMODE_BLEND.
	
	cairoSurface := AeCairoImageSurface
		newForData: sdlSurface pixels
		extent: pixelExtent
		stride: sdlSurface pitch
		format: AeCairoSurfaceFormat argb32.
	cairoSurface deviceScale: deviceScalePoint.

	cairoContext := cairoSurface newContext.

]
