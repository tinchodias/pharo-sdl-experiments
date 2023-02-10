"
I'm a tile that's specialized to override the whole SDL window on each render.

"
Class {
	#name : #WholeWindowTile,
	#superclass : #StaticTextureTile,
	#category : #'SDLExperiments-Manager-Cairo'
}

{ #category : #'life cycle' }
WholeWindowTile >> createTexture [

	sdlTexture := sdlRenderer
		createTextureFormat: SDL_PIXELFORMAT_XRGB8888
		access: SDL_TEXTUREACCESS_STATIC
		width: pixelExtent x
		height: pixelExtent y.
	"sdlTexture blendMode: SDL_BLENDMODE_NONE. --> default"
	
	cairoSurface := AeCairoImageSurface
		extent: pixelExtent
		format: AeCairoSurfaceFormat rgb24. "ew know it's 32 bits anyway"
	cairoSurface deviceScale: deviceScalePoint.

	cairoContext := cairoSurface newContext.
	"Default source is color white"
	cairoContext sourceColorR: 1.0 g: 1.0 b: 1.0 a: 1.0.

	cairoSurfaceStride := cairoSurface stride.
	cairoSurfacePixels := cairoSurface data

]

{ #category : #rendering }
WholeWindowTile >> renderWith: aBlock [

	"clear background (white)"
	cairoContext paint.

	"Assume context is restored in block"
	aBlock value.

	cairoSurface flush.
	sdlTexture
		updateTextureRect: SDL_Rect null
			pixels: cairoSurfacePixels
			pitch:  cairoSurfaceStride.
	sdlRenderer copy: sdlTexture
]
